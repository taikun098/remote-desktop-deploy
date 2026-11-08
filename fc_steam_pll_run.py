# -*- coding: utf-8 -*-
import paramiko, time
HOST="192.168.0.20"; USER="user"
KEY=r"C:\Users\user\.ssh\id_ed25519"
def conn():
    c=paramiko.SSHClient(); c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    c.connect(HOST, username=USER, key_filename=KEY, timeout=25)
    c.get_transport().set_keepalive(15)
    return c
# 先提交
c=conn()
sftp=c.open_sftp(); sftp.put(r"C:\Users\user\Doubao\chats\2026-11-01\new-chat-2\fc_steam_launch.sh","/tmp/fc_steam_launch.sh"); sftp.close()
_,so,_=c.exec_command("bash /tmp/fc_steam_launch.sh", timeout=30)
print(so.read().decode("utf-8","replace"))
c.close()
# 轮询直到两个单元都结束
def active(unit):
    c=conn(); _,so,_=c.exec_command("systemctl is-active %s"%unit, timeout=30); st=so.read().decode().strip(); c.close()
    return st=="active"
for i in range(60):
    a=active("steam-install"); b=active("fc-dl")
    print("轮询%02d steam=%s fc=%s"%(i,a,b))
    if not a and not b: break
    time.sleep(15)
# 读结果
c=conn()
sftp=c.open_sftp(); sftp.put(r"C:\Users\user\Doubao\chats\2026-11-01\new-chat-2\fc_steam_pll.sh","/tmp/fc_steam_pll.sh"); sftp.close()
_,so,se=c.exec_command("bash /tmp/fc_steam_pll.sh", timeout=40)
print(so.read().decode("utf-8","replace"))
e=se.read().decode("utf-8","replace")
if e.strip(): print("[e]"+e)
c.close()
