# -*- coding: utf-8 -*-
import paramiko, time
HOST="192.168.0.20"; USER="user"
KEY=r"C:\Users\user\.ssh\id_ed25519"
print("等待 75 秒让机器重启...")
time.sleep(75)
connected=False
for i in range(24):
    try:
        c=paramiko.SSHClient(); c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        c.connect(HOST, username=USER, key_filename=KEY, timeout=12)
        # uptime 判断是否新开机
        _,so,_=c.exec_command("uptime -p; uptime -s", timeout=15)
        up=so.read().decode("utf-8","replace").strip()
        print(f"[{i}] SSH 已连回。uptime: {up}")
        connected=True
        c.close()
        break
    except Exception as e:
        print(f"[{i}] 等待中... {type(e).__name__}")
        time.sleep(10)
if not connected:
    print("机器未在 4 分钟内连回，请检查")
else:
    print("=== 机器已回来，开始验证 ===")
