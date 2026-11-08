# -*- coding: utf-8 -*-
import paramiko
HOST="192.168.0.20"; USER="user"
KEY=r"C:\Users\user\.ssh\id_ed25519"
c=paramiko.SSHClient(); c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
c.connect(HOST, username=USER, key_filename=KEY, timeout=25)
cmd="echo 1 | sudo -S bash -c 'dpkg -l | grep -E \"mesa-va-drivers|vainfo\" | head; echo ---; command -v vainfo; echo ---LOCK---; fuser /var/lib/dpkg/lock-frontend 2>/dev/null && echo apt锁定中 || echo apt空闲; echo ---21116---; ss -tlnp 2>/dev/null | grep 21116 || echo 未监听; echo ---LOG---; sudo -u lightdm tail -4 /var/lib/lightdm/.local/share/logs/RustDesk/server/rustdesk_rCURRENT.log 2>/dev/null'"
_,so,se=c.exec_command(cmd, timeout=35)
out=so.read().decode("utf-8","replace")
print(out.replace("\x00",""))
e=se.read().decode("utf-8","replace")
if e.strip(): print("[e] "+e)
c.close()
