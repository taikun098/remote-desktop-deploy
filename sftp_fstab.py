# -*- coding: utf-8 -*-
import paramiko
HOST="192.168.0.20"; USER="user"
KEY=r"C:\Users\user\.ssh\id_ed25519"
LOCAL=r"C:\Users\user\Doubao\chats\2026-11-01\new-chat-2\fstab.append"
REMOTE="/tmp/fstab.append"
c=paramiko.SSHClient(); c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
c.connect(HOST, username=USER, key_filename=KEY, timeout=20)
sftp=c.open_sftp(); sftp.put(LOCAL, REMOTE)
print("uploaded", REMOTE, flush=True)
stdin,so,se=c.exec_command("wc -c /tmp/fstab.append; cat -A /tmp/fstab.append")
print(so.read().decode(), flush=True)
sftp.close(); c.close()
