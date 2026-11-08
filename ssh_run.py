#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Reusable SSH command runner via paramiko. Usage:
    python ssh_run.py "<command1>;;<command2>;;..."
Runs commands via bash -lc '...' on the remote host.
"""
import sys
import paramiko

HOST = "192.168.0.20"
USER = "user"
PASS="******"

def main():
    cmds = []
    for arg in sys.argv[1:]:
        cmds.extend(a for a in arg.split(";;") if a.strip())
    if not cmds:
        print("no command")
        return
    c = paramiko.SSHClient()
    c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    try:
        c.connect(HOST, port=22, username=USER, password=****** timeout=15,
                  allow_agent=False, look_for_keys=False)
    except Exception as e:
        print("CONNECT_ERROR:", repr(e))
        sys.exit(1)
    for cmd in cmds:
        print(f"### $ {cmd}")
        stdin, stdout, stderr = c.exec_command(f"bash -lc {paramiko.util.quote(cmd)}", timeout=120)
        out = stdout.read().decode("utf-8", "replace")
        err = stderr.read().decode("utf-8", "replace")
        if out:
            print(out.rstrip())
        if err:
            print("[stderr]", err.rstrip())
    c.close()

if __name__ == "__main__":
    main()
