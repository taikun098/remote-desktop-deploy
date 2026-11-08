#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Reusable SSH runner via paramiko key auth (proven pattern).
Usage: python sshexec.py "<cmd1>;;<cmd2>;;..."
"""
import sys, shlex, traceback, paramiko

HOST = "192.168.0.20"; USER = "user"
KEY = r"C:\Users\user\.ssh\id_ed25519"

def main():
    cmds = []
    for a in sys.argv[1:]:
        cmds.extend(x for x in a.split(";;") if x.strip())
    if not cmds:
        print("no command", flush=True); return
    c = paramiko.SSHClient()
    c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    try:
        c.connect(HOST, port=22, username=USER, key_filename=KEY,
                  timeout=20, allow_agent=False, look_for_keys=False)
    except Exception:
        print("CONNECT_ERROR:", flush=True); traceback.print_exc(); sys.exit(1)
    try:
        for cmd in cmds:
            print("### $ " + cmd, flush=True)
            _, so, se = c.exec_command("bash -lc " + shlex.quote(cmd), timeout=300)
            out = so.read().decode("utf-8", "replace")
            err = se.read().decode("utf-8", "replace")
            if out: print(out.rstrip(), flush=True)
            if err: print("[stderr] " + err.rstrip(), flush=True)
    except Exception:
        traceback.print_exc()
    finally:
        c.close()

if __name__ == "__main__":
    main()
