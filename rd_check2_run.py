# -*- coding: utf-8 -*-
import paramiko, time
HOST="192.168.0.20"; USER="user"
KEY=r"C:\Users\user\.ssh\id_ed25519"
c=paramiko.SSHClient(); c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
c.connect(HOST, username=USER, key_filename=KEY, timeout=25)
print("等待 60 秒...")
time.sleep(60)
cmd="echo 1 | sudo -S bash -c 'echo PID=$(ps -eo pid,args | grep \"rustdesk --server\" | grep -v grep | awk \"{print \\$1}\" | tail -1); echo ===21116===; ss -tlnp 2>/dev/null | grep 21116 || echo TCP未监听; ss -ulnp 2>/dev/null | grep 21116 || echo UDP未监听; echo ===监听===; ss -tlnp 2>/dev/null | grep rustdesk; ss -ulnp 2>/dev/null | grep rustdesk; echo ===日志===; sudo -u lightdm tail -14 /var/lib/lightdm/.local/share/logs/RustDesk/server/rustdesk_rCURRENT.log 2>/dev/null; echo ===状态===; systemctl is-active rustdesk.service'"
_,so,se=c.exec_command(cmd, timeout=40)
out=so.read().decode("utf-8","replace")
print(out.replace("\x00",""))
e=se.read().decode("utf-8","replace")
if e.strip(): print("[e] "+e)
c.close()
