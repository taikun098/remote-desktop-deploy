# -*- coding: utf-8 -*-
import paramiko, time
HOST="192.168.0.20"; USER="user"
KEY=r"C:\Users\user\.ssh\id_ed25519"
def conn():
    c=paramiko.SSHClient(); c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    c.connect(HOST, username=USER, key_filename=KEY, timeout=25)
    c.get_transport().set_keepalive(15); return c
c=conn(); sftp=c.open_sftp(); sftp.put(r"C:\Users\user\Doubao\chats\2026-11-01\new-chat-2\ll_env3.sh","/tmp/ll_env3.sh"); sftp.close()
_,so,_=c.exec_command("bash /tmp/ll_env3.sh", timeout=30); print(so.read().decode()); c.close()
def active(u):
    c=conn(); _,so,_=c.exec_command("systemctl is-active %s"%u, timeout=30); st=so.read().decode().strip(); c.close(); return st=="active"
for i in range(40):
    if not active("ll-env2"): print("ll-env2 结束"); break
    if i%4==0: print("轮询%02d active"%(i))
    time.sleep(15)
c=conn()
_,so,se=c.exec_command("echo '=== ll-cli ==='; which ll-cli && ll-cli --version 2>/dev/null | head -1; echo '=== 包 ==='; dpkg -l 2>/dev/null | grep -iE 'linglong-(bin|installer)' | awk '{print \$2,\$3}'; echo '=== journal ==='; journalctl -u ll-env2 --no-pager 2>/dev/null | grep -iE '无法|Err|DONE|已安装|解压|设置' | tail -6", timeout=40)
print(so.read().decode())
e=se.read().decode()
if e.strip(): print("[e]"+e)
c.close()
