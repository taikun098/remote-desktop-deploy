# -*- coding: utf-8 -*-
import paramiko, sys
HOST="192.168.0.20"; USER="user"
KEY=r"C:\Users\user\.ssh\id_ed25519"
LOCAL=r"C:\Users\user\Doubao\chats\2026-11-01\new-chat-2\ubuntu.sources.new"
REMOTE="/tmp/ubuntu.sources.new"
c=paramiko.SSHClient(); c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
c.connect(HOST, username=USER, key_filename=KEY, timeout=20)
sftp=c.open_sftp()
sftp.put(LOCAL, REMOTE)
print("uploaded to", REMOTE, flush=True)
# verify line endings (should be no \r)
stdin,so,se=c.exec_command("wc -c /tmp/ubuntu.sources.new; cat -A /tmp/ubuntu.sources.new | head -5")
print(so.read().decode(), flush=True)
sftp.close(); c.close()
