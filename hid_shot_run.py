# -*- coding: utf-8 -*-
import paramiko
HOST="192.168.0.20"; USER="user"
KEY=r"C:\Users\user\.ssh\id_ed25519"
c=paramiko.SSHClient(); c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
c.connect(HOST, username=USER, key_filename=KEY, timeout=25)
sftp=c.open_sftp(); sftp.put(r"C:\Users\user\Doubao\chats\2026-11-01\new-chat-2\hid_shot.sh","/tmp/hid_shot.sh"); sftp.close()
c.get_transport().set_keepalive(15)
_,so,se=c.exec_command("bash /tmp/hid_shot.sh", timeout=55)
out=so.read().decode("utf-8","replace")
print(out.replace("\x00",""))
e=se.read().decode("utf-8","replace")
if e.strip(): print("[e] "+e)
# 拉截图回来
try:
    sftp2=c.open_sftp(); sftp2.get("/tmp/wp.png", r"C:\Users\user\Doubao\chats\2026-11-01\new-chat-2\hid_wp.png"); sftp2.close(); print("[screenshot fetched]")
except Exception as ex:
    print("[screenshot fetch failed]", ex)
c.close()
