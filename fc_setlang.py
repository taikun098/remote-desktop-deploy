# -*- coding: utf-8 -*-
import paramiko
HOST="192.168.0.20"; USER="user"
KEY=r"C:\Users\user\.ssh\id_ed25519"
c=paramiko.SSHClient(); c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
c.connect(HOST, username=USER, key_filename=KEY, timeout=25)
sftp=c.open_sftp()
sftp.put(r"C:\Users\user\Doubao\chats\2026-11-01\new-chat-2\setlang.py","/tmp/setlang.py")
sftp.close()
def run(cmd, t=180):
    print("### $ "+cmd, flush=True)
    _,so,se=c.exec_command(cmd, timeout=t)
    print(so.read().decode("utf-8","replace").rstrip(), flush=True)
    e=se.read().decode("utf-8","replace")
    if e.strip(): print("[e] "+e.rstrip(), flush=True)
run("echo '===qm files==='; find /opt/freecad/squashfs-root -name '*.qm' 2>/dev/null | grep -iE 'zh|cn' | head -5; find /opt/freecad/squashfs-root -type d -iname 'translations' 2>/dev/null | head")
run("echo 1 | sudo -S env HOME=/root QT_QPA_PLATFORM=offscreen /opt/freecad/squashfs-root/usr/bin/freecadcmd /tmp/setlang.py 2>&1 | tail -30")
run("echo '===user.cfg==='; echo 1 | sudo -S cat /root/.config/FreeCAD/v1-1/user.cfg 2>/dev/null || echo no_user_cfg")
c.close()
