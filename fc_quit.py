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
run("echo 1 | sudo -S pkill -x FreeCAD.AppImage; sleep 6; pgrep -x FreeCAD.AppImage | head -2 || echo no_proc")
run("echo '===find cfg==='; sudo find /root -maxdepth 5 -name 'user.cfg' 2>/dev/null; echo '===fc dir==='; sudo ls -la /root/.config/ 2>/dev/null | grep -i freecad; sudo find /root/.config -maxdepth 2 -iname '*freecad*' 2>/dev/null")
run("echo '===log==='; sudo tail -c 3000 /tmp/fc_run.log | tr '\\r' '\\n' | tail -25")
c.close()
