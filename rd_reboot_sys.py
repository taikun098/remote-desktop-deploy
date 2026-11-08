# -*- coding: utf-8 -*-
import paramiko, time
HOST="192.168.0.20"; USER="user"
KEY=r"C:\Users\user\.ssh\id_ed25519"
# 1) 确认 D 状态
c=paramiko.SSHClient(); c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
c.connect(HOST, username=USER, key_filename=KEY, timeout=25)
_,so,se=c.exec_command("echo 1 | sudo -S bash -c 'ps -o pid,stat,wchan:20,args -p 28001'", timeout=20)
print("=== 28001 状态 ===")
print(so.read().decode("utf-8","replace"))
# 2) 触发重启
print("=== 触发重启 ===")
_,so,se=c.exec_command("echo 1 | sudo -S systemctl reboot", timeout=10)
print(so.read().decode("utf-8","replace"))
e=se.read().decode("utf-8","replace")
if e.strip(): print("[e] "+e)
c.close()
print("重启命令已发出，SSH 即将断开。等待机器回来...")
