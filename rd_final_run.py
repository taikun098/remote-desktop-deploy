# -*- coding: utf-8 -*-
import paramiko
HOST="192.168.0.20"; USER="user"
KEY=r"C:\Users\user\.ssh\id_ed25519"
c=paramiko.SSHClient(); c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
c.connect(HOST, username=USER, key_filename=KEY, timeout=25)
cmd="echo 1 | sudo -S bash -c 'echo ===状态===; systemctl is-active rustdesk.service; echo ===21116===; ss -tlnp 2>/dev/null | grep 21116 || echo TCP未监听; ss -ulnp 2>/dev/null | grep 21116 || echo UDP未监听; echo ===全部监听===; ss -tlnp 2>/dev/null | grep rustdesk; ss -ulnp 2>/dev/null | grep rustdesk; echo ===日志尾部===; sudo -u lightdm tail -12 /var/lib/lightdm/.local/share/logs/RustDesk/server/rustdesk_rCURRENT.log 2>/dev/null'"
_,so,se=c.exec_command(cmd, timeout=35)
out=so.read().decode("utf-8","replace")
print(out.replace("\x00",""))
e=se.read().decode("utf-8","replace")
if e.strip(): print("[e] "+e)
c.close()
