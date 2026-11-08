# -*- coding: utf-8 -*-
import paramiko, time
HOST="192.168.0.20"; USER="user"
KEY=r"C:\Users\user\.ssh\id_ed25519"
start=time.time()
ok=False
for i in range(60):
    try:
        c=paramiko.SSHClient(); c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        c.connect(HOST, username=USER, key_filename=KEY, timeout=8)
        ok=True
        print(f"[{int(time.time()-start)}s] 连回成功")
        # 等系统完全就绪（桌面+服务）
        time.sleep(20)
        c.close()
        break
    except Exception as e:
        print(f"[{int(time.time()-start)}s] 等待中: {type(e).__name__}")
        time.sleep(8)
if not ok:
    print("超过等待时间仍未连回")
