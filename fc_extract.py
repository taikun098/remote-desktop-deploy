# -*- coding: utf-8 -*-
import paramiko
HOST="192.168.0.20"; USER="user"
KEY=r"C:\Users\user\.ssh\id_ed25519"
c=paramiko.SSHClient(); c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
c.connect(HOST, username=USER, key_filename=KEY, timeout=25)
def run(cmd, t=300):
    print("### $ "+cmd, flush=True)
    _,so,se=c.exec_command(cmd, timeout=t)
    print(so.read().decode("utf-8","replace").rstrip(), flush=True)
    e=se.read().decode("utf-8","replace")
    if e.strip(): print("[e] "+e.rstrip(), flush=True)
run("cd /opt/freecad && echo 1 | sudo -S /opt/freecad/FreeCAD.AppImage --appimage-extract > /tmp/fc_extract.log 2>&1; echo extract_rc=$?; ls -d /opt/freecad/squashfs-root 2>/dev/null")
run("echo '===bin==='; ls /opt/freecad/squashfs-root/usr/bin/ 2>/dev/null | grep -iE 'freecad|cmd' ; echo '===translations==='; ls /opt/freecad/squashfs-root/usr/share/FreeCAD/translations/ 2>/dev/null | grep -iE 'zh|cn|chinese' | head")
c.close()
