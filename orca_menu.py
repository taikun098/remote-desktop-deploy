# -*- coding: utf-8 -*-
import paramiko, time
HOST="192.168.0.20"; USER="user"
KEY=r"C:\Users\user\.ssh\id_ed25519"
c=paramiko.SSHClient(); c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
c.connect(HOST, username=USER, key_filename=KEY, timeout=25)
def run(cmd, t=60, sudo=False):
    if sudo: cmd="echo 1 | sudo -S bash -c '%s'"%cmd.replace("'","'\\''")
    print("### $ "+cmd, flush=True)
    _,so,se=c.exec_command(cmd, timeout=t)
    o=so.read().decode("utf-8","replace").rstrip()
    if o.strip(): print(o, flush=True)
    e=se.read().decode("utf-8","replace")
    if e.strip(): print("[e] "+e.rstrip(), flush=True)
# 建菜单项（用 printf 避免 sftp 再次断）
desktop='[Desktop Entry]\nVersion=1.0\nType=Application\nName=OrcaSlicer\nName[zh_CN]=OrcaSlicer 切片\nComment=3D Printing Slicer\nExec=/usr/local/bin/orcaslicer %F\nIcon=applications-development\nCategories=Graphics;3DPrinting;\nTerminal=false\n'
run('echo 1 | sudo -S bash -c "printf \\"%s\\" > /usr/share/applications/orcaslicer.desktop && cat /usr/share/applications/orcaslicer.desktop"' % desktop.replace('"','\\"'), sudo=False)
c.close()
