# -*- coding: utf-8 -*-
import paramiko, time
HOST="192.168.0.20"; USER="user"
KEY=r"C:\Users\user\.ssh\id_ed25519"
def conn():
    c=paramiko.SSHClient(); c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    c.connect(HOST, username=USER, key_filename=KEY, timeout=25)
    c.get_transport().set_keepalive(15); return c
c=conn(); sftp=c.open_sftp(); sftp.put(r"C:\Users\user\Doubao\chats\2026-11-01\new-chat-2\fc_snapinst.sh","/tmp/fc_snapinst.sh"); sftp.close()
_,so,_=c.exec_command("bash /tmp/fc_snapinst.sh", timeout=30); print(so.read().decode()); c.close()
def active():
    c=conn(); _,so,_=c.exec_command("systemctl is-active fc-snap", timeout=30); st=so.read().decode().strip(); c.close(); return st=="active"
for i in range(40):
    if not active(): print("fc-snap 结束"); break
    if i%4==0: print("轮询%02d fc-snap=%s"%(i,"active"))
    time.sleep(15)
c=conn(); sftp=c.open_sftp(); sftp.put(r"C:\Users\user\Doubao\chats\2026-11-01\new-chat-2\fc_snappll.sh","/tmp/fc_snappll.sh"); sftp.close()
_,so,se=c.exec_command("bash /tmp/fc_snappll.sh", timeout=60); print(so.read().decode());
e=se.read().decode();
if e.strip(): print("[e]"+e)
c.close()
