# -*- coding: utf-8 -*-
import paramiko
HOST="192.168.0.20"; USER="user"
KEY=r"C:\Users\user\.ssh\id_ed25519"
try:
    c=paramiko.SSHClient(); c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    c.connect(HOST, username=USER, key_filename=KEY, timeout=12)
    _,so,_=c.exec_command("uptime; echo ---; cat /sys/class/tty/tty0/active; echo ---; systemctl is-active rustdesk", timeout=15)
    print(so.read().decode("utf-8","replace"))
    c.close()
except Exception as e:
    print("连接失败:", type(e).__name__, e)
