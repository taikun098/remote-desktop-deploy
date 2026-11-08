# -*- coding: utf-8 -*-
import paramiko
HOST="192.168.0.20"; USER="user"
KEY=r"C:\Users\user\.ssh\id_ed25519"
c=paramiko.SSHClient(); c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
c.connect(HOST, username=USER, key_filename=KEY, timeout=25)
cmd="echo 1 | sudo -S bash -c 'echo ---IPV4_CONNECT---; grep -E \"connect\\(.*AF_INET\" /tmp/rd_strace.log 2>/dev/null | grep -vE \"127.0.0.53|sa_family=AF_UNIX\" | head -25; echo ---YC_IP---; grep -c \"36.102.85.112\" /tmp/rd_strace.log 2>/dev/null; echo ---DNS_QUERIES_by_host---; grep -E \"connect.*:53\" /tmp/rd_strace.log 2>/dev/null | head -8; echo ---getaddrinfo---; grep -cE \"getaddrinfo|res_send\" /tmp/rd_strace.log 2>/dev/null'"
_,so,se=c.exec_command(cmd, timeout=40)
out=so.read().decode("utf-8","replace")
print(out.replace("\x00",""))
e=se.read().decode("utf-8","replace")
if e.strip(): print("[e] "+e)
c.close()
