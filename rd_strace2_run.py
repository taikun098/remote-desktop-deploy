# -*- coding: utf-8 -*-
import paramiko
HOST="192.168.0.20"; USER="user"
KEY=r"C:\Users\user\.ssh\id_ed25519"
c=paramiko.SSHClient(); c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
c.connect(HOST, username=USER, key_filename=KEY, timeout=25)
cmd="echo 1 | sudo -S bash -c 'wc -l /tmp/rd_strace.log 2>/dev/null; echo ---CONNECT---; grep -E \"connect\\(|bind\\(\" /tmp/rd_strace.log 2>/dev/null | head -30; echo ---SOCKET---; grep -E \"socket\\(AF_INET\" /tmp/rd_strace.log 2>/dev/null | head -10; echo ---SRVOUT---; head -40 /tmp/rd_srv_out.log 2>/dev/null; echo ---PORTS---; ss -tlnp 2>/dev/null | grep rustdesk'"
_,so,se=c.exec_command(cmd, timeout=40)
out=so.read().decode("utf-8","replace")
print(out.replace("\x00",""))
e=se.read().decode("utf-8","replace")
if e.strip(): print("[e] "+e)
c.close()
