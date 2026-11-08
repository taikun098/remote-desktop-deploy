# -*- coding: utf-8 -*-
import paramiko, time
HOST="192.168.0.20"; USER="user"
KEY=r"C:\Users\user\.ssh\id_ed25519"
print("再尝试连接...")
for i in range(20):
    try:
        c=paramiko.SSHClient(); c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        c.connect(HOST, username=USER, key_filename=KEY, timeout=10)
        _,so,se=c.exec_command("uptime -p; uptime -s; hostname", timeout=15)
        out=so.read().decode("utf-8","replace").strip()
        print(f"[{i}] 连上了: {out}")
        c.close()
        print("OK")
        break
    except Exception as e:
        print(f"[{i}] {type(e).__name__}: {e}")
        time.sleep(10)
