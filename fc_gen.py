# -*- coding: utf-8 -*-
import paramiko, time
HOST="192.168.0.20"; USER="user"
KEY=r"C:\Users\user\.ssh\id_ed25519"
c=paramiko.SSHClient(); c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
c.connect(HOST, username=USER, key_filename=KEY, timeout=25)
def run(cmd, t=120):
    print("### $ "+cmd, flush=True)
    _,so,se=c.exec_command(cmd, timeout=t)
    print(so.read().decode("utf-8","replace").rstrip(), flush=True)
    e=se.read().decode("utf-8","replace")
    if e.strip(): print("[e] "+e.rstrip(), flush=True)
run("echo 1 | sudo -S pkill -9 -f 'opt/freecad/FreeCAD.AppImage$'; sleep 3; echo 1 | sudo -S pgrep -f 'opt/freecad/FreeCAD.AppImage$' || echo dead")
run("echo 1 | sudo -S rm -f /root/.config/FreeCAD/v1-1/user.cfg; echo removed_malformed")
run("echo 1 | sudo -S setsid env HOME=/root DISPLAY=:0 /opt/freecad/FreeCAD.AppImage > /tmp/fc_gen.log 2>&1 & echo launched", t=30)
time.sleep(28)
run("echo '===proc==='; echo 1 | sudo -S pgrep -f 'opt/freecad/FreeCAD.AppImage$' || echo NOT_RUNNING")
run("echo 1 | sudo -S pkill -TERM -f 'opt/freecad/FreeCAD.AppImage$'; sleep 6; echo '===proc after TERM==='; echo 1 | sudo -S pgrep -f 'opt/freecad/FreeCAD.AppImage$' || echo exited")
run("echo '===generated user.cfg==='; echo 1 | sudo -S cat /root/.config/FreeCAD/v1-1/user.cfg 2>/dev/null || echo no_user_cfg")
run("echo '===log==='; echo 1 | sudo -S tail -c 2000 /tmp/fc_gen.log | tr '\\r' '\\n' | tail -15")
c.close()
