# -*- coding: utf-8 -*-
import paramiko, time
HOST="192.168.0.20"; USER="user"
KEY=r"C:\Users\user\.ssh\id_ed25519"
c=paramiko.SSHClient(); c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
c.connect(HOST, username=USER, key_filename=KEY, timeout=25)
sftp=c.open_sftp()
sftp.put(r"C:\Users\user\Doubao\chats\2026-11-01\new-chat-2\fc_user.cfg","/tmp/fc_user.cfg")
sftp.close()
def run(cmd, t=120):
    print("### $ "+cmd, flush=True)
    _,so,se=c.exec_command(cmd, timeout=t)
    print(so.read().decode("utf-8","replace").rstrip(), flush=True)
    e=se.read().decode("utf-8","replace")
    if e.strip(): print("[e] "+e.rstrip(), flush=True)
run("echo 1 | sudo -S cp /tmp/fc_user.cfg /root/.config/FreeCAD/v1-1/user.cfg && echo 1 | sudo -S chmod 644 /root/.config/FreeCAD/v1-1/user.cfg && echo cfg_installed")
run("echo 1 | sudo -S cat /root/.config/FreeCAD/v1-1/user.cfg")
run("echo 1 | sudo -S setsid env HOME=/root DISPLAY=:0 /opt/freecad/FreeCAD.AppImage > /tmp/fc_run2.log 2>&1 & echo launched", t=30)
time.sleep(25)
run("echo '===proc==='; echo 1 | sudo -S pgrep -x FreeCAD.AppImag || echo NOT_RUNNING")
run("echo '===user.cfg after run==='; echo 1 | sudo -S cat /root/.config/FreeCAD/v1-1/user.cfg 2>/dev/null | head -12 || echo no_user_cfg")
run("echo '===log==='; echo 1 | sudo -S tail -c 1500 /tmp/fc_run2.log | tr '\\r' '\\n' | tail -12")
c.close()
