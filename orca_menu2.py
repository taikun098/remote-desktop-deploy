# -*- coding: utf-8 -*-
import paramiko
HOST="192.168.0.20"; USER="user"
KEY=r"C:\Users\user\.ssh\id_ed25519"
c=paramiko.SSHClient(); c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
c.connect(HOST, username=USER, key_filename=KEY, timeout=25)
desktop="""[Desktop Entry]
Version=1.0
Type=Application
Name=OrcaSlicer
Name[zh_CN]=OrcaSlicer 切片
Comment=3D Printing Slicer
Exec=/usr/local/bin/orcaslicer %F
Icon=applications-development
Categories=Graphics;3DPrinting;
Terminal=false
"""
# 用 sudo tee 从 stdin 写入，绕开 printf 的 % 转义
cmd="echo 1 | sudo -S tee /usr/share/applications/orcaslicer.desktop >/dev/null"
stdin,stdout,stderr=c.exec_command(cmd, timeout=30)
stdin.write(desktop)
stdin.channel.shutdown_write()
out=stdout.read().decode(); err=stderr.read().decode()
print("write rc done")
# 回读验证
_,so,se=c.exec_command("cat /usr/share/applications/orcaslicer.desktop", timeout=20)
print(so.read().decode())
c.close()
