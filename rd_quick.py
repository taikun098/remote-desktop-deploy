# -*- coding: utf-8 -*-
import paramiko
HOST="192.168.0.20"; USER="user"
KEY=r"C:\Users\user\.ssh\id_ed25519"
for i in range(3):
    try:
        c=paramiko.SSHClient(); c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        c.connect(HOST, username=USER, key_filename=KEY, timeout=8)
        _,so,_=c.exec_command("uptime -s", timeout=10)
        print("OK uptime_s=", so.read().decode().strip())
        c.close(); break
    except Exception as e:
        print(f"[{i}] {type(e).__name__}")
        import time; time.sleep(8)
