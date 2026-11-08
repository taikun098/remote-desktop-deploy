# -*- coding: utf-8 -*-
import paramiko
HOST="192.168.0.20"; USER="user"
KEY=r"C:\Users\user\.ssh\id_ed25519"
LOCAL=r"C:\Users\user\Doubao\chats\2026-11-01\new-chat-2\mount_plan.sh"
REMOTE="/tmp/mount_plan.sh"
c=paramiko.SSHClient(); c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
c.connect(HOST, username=USER, key_filename=KEY, timeout=20)
sftp=c.open_sftp()
sftp.put(LOCAL, REMOTE)
sftp.chmod(REMOTE, 0o755)
print("uploaded to", REMOTE, flush=True)
# confirm on server
stdin,so,se=c.exec_command("ls -l /tmp/mount_plan.sh; head -3 /tmp/mount_plan.sh")
print(so.read().decode(), flush=True)
sftp.close(); c.close()
