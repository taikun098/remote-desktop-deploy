# -*- coding: utf-8 -*-
import paramiko
HOST="192.168.0.20"; USER="user"
KEY=r"C:\Users\user\.ssh\id_ed25519"
c=paramiko.SSHClient(); c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
c.connect(HOST, username=USER, key_filename=KEY, timeout=25)
sftp=c.open_sftp(); sftp.put(r"C:\Users\user\Doubao\chats\2026-11-01\new-chat-2\rd_log.sh","/tmp/rd_log.sh"); sftp.close()
_,so,se=c.exec_command("echo 1 | sudo -S bash /tmp/rd_log.sh", timeout=40)
print(so.read().decode("utf-8","replace"))
e=se.read().decode("utf-8","replace")
if e.strip(): print("[e] "+e)
c.close()
