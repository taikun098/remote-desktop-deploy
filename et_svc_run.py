# -*- coding: utf-8 -*-
import paramiko
HOST="192.168.0.20"; USER="user"
KEY=r"C:\Users\user\.ssh\id_ed25519"
c=paramiko.SSHClient(); c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
c.connect(HOST, username=USER, key_filename=KEY, timeout=25)
sftp=c.open_sftp()
sftp.put(r"C:\Users\user\Doubao\chats\2026-11-01\new-chat-2\easytier.service","/tmp/easytier.service")
sftp.close()
cmd = r"""
set -e
sudo -n cp /tmp/easytier.service /etc/systemd/system/easytier.service
echo "--- unit installed ---"
sudo -n systemctl daemon-reload
echo "--- enable + start ---"
sudo -n systemctl enable easytier.service
sudo -n systemctl start easytier.service
sleep 3
echo "--- status ---"
sudo -n systemctl is-active easytier.service
echo "--- tun ---"
ip -4 addr show tun0 2>/dev/null | grep -E 'inet 10\.|tun0' || echo "(no tun0 yet)"
echo "--- service unit ---"
cat /etc/systemd/system/easytier.service
echo "--- process ---"
ps -eo pid,args | grep '[e]asytier-core' || echo "(no process)"
"""
_,so,se=c.exec_command("echo 1 | sudo -S bash -c '"+cmd+"'", timeout=60)
print(so.read().decode("utf-8","replace"))
e=se.read().decode("utf-8","replace")
if e.strip(): print("[e] "+e)
c.close()
