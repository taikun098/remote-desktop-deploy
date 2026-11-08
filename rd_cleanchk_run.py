# -*- coding: utf-8 -*-
import paramiko
HOST="192.168.0.20"; USER="user"
KEY=r"C:\Users\user\.ssh\id_ed25519"
c=paramiko.SSHClient(); c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
c.connect(HOST, username=USER, key_filename=KEY, timeout=25)
c.get_transport().set_keepalive(15)
cmd="echo 1 | sudo -S bash -c 'echo ===Xorg===; ps -eo pid,args | grep \"[X]org\"; echo ===活动VT===; cat /sys/class/tty/tty0/active; echo ===会话===; loginctl list-sessions; echo ===rustdesk-server===; ps -eo pid,args | grep \"[r]ustdesk --server\"; echo ===rustdesk服务===; systemctl is-active rustdesk.service'"
_,so,se=c.exec_command(cmd, timeout=30)
out=so.read().decode("utf-8","replace")
print(out.replace("\x00",""))
e=se.read().decode("utf-8","replace")
if e.strip(): print("[e] "+e)
c.close()
