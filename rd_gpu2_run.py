# -*- coding: utf-8 -*-
import paramiko, time
HOST="192.168.0.20"; USER="user"
KEY=r"C:\Users\user\.ssh\id_ed25519"
c=paramiko.SSHClient(); c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
c.connect(HOST, username=USER, key_filename=KEY, timeout=25)
sftp=c.open_sftp(); sftp.put(r"C:\Users\user\Doubao\chats\2026-11-01\new-chat-2\rd_gpu2.sh","/tmp/rd_gpu2.sh"); sftp.close()
# 用 nohup 后台跑，脚本自身用 timeout 限时，避免 paramiko 卡
c.exec_command("echo 1 | sudo -S nohup bash /tmp/rd_gpu2.sh >/dev/null 2>&1 &")
time.sleep(25)
_,so,se=c.exec_command("cat /tmp/rd_gpu2.txt", timeout=25)
out=so.read().decode("utf-8","replace")
print(out.replace("\x00",""))
e=se.read().decode("utf-8","replace")
if e.strip(): print("[e] "+e)
c.close()
