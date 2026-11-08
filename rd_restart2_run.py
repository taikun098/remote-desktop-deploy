# -*- coding: utf-8 -*-
import paramiko
HOST="192.168.0.20"; USER="user"
KEY=r"C:\Users\user\.ssh\id_ed25519"
c=paramiko.SSHClient(); c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
c.connect(HOST, username=USER, key_filename=KEY, timeout=25)
c.get_transport().set_keepalive(15)
chan=c.get_transport().open_session()
chan.settimeout(35)
chan.exec_command("echo 1 | sudo -S bash -c 'systemctl restart rustdesk.service; sleep 2; echo restarted-pid=$(ps -eo pid,args | grep \"rustdesk --server\" | grep -v grep | awk \"{print \\$1}\" | tail -1)'")
out=chan.makefile().read().decode("utf-8","replace")
print(out.replace("\x00",""))
e=chan.makefile_stderr().read().decode("utf-8","replace")
if e.strip(): print("[e] "+e)
c.close()
