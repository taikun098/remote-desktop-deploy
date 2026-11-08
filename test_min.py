# -*- coding: utf-8 -*-
import shlex, paramiko
print("script start", flush=True)
c = paramiko.SSHClient()
c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
try:
    c.connect("192.168.0.20", port=22, username="user",
              key_filename=r"C:\Users\user\.ssh\id_ed25519",
              timeout=20, allow_agent=False, look_for_keys=False)
    print("connected OK", flush=True)
except Exception as e:
    print("CONNECT_ERROR:", repr(e), flush=True)
    raise SystemExit(1)
cmd = "echo KEY_OK && whoami && hostname && uname -a"
stdin, stdout, stderr = c.exec_command(f"bash -lc {shlex.quote(cmd)}", timeout=120)
out = stdout.read().decode("utf-8","replace")
err = stderr.read().decode("utf-8","replace")
print("STDOUT:", repr(out), flush=True)
print("STDERR:", repr(err), flush=True)
print("exit_remote:", stdout.channel.recv_exit_status(), flush=True)
c.close()
print("done", flush=True)
