# -*- coding: utf-8 -*-
import paramiko, time
HOST="192.168.0.20"; USER="user"
KEY=r"C:\Users\user\.ssh\id_ed25519"
def ssh():
    c=paramiko.SSHClient(); c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    c.connect(HOST, username=USER, key_filename=KEY, timeout=20)
    return c
try:
    c=ssh()
    c.get_transport().set_keepalive(15)
    _,so,se=c.exec_command("echo 1 | sudo -S systemctl reboot", timeout=15)
    try: so.read()
    except: pass
    print("已发送重启命令，SSH 即将断开")
    c.close()
except Exception as e:
    print("重启触发失败(可能已断):", type(e).__name__, e)
