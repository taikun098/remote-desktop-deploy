# -*- coding: utf-8 -*-
import paramiko, time
HOST="192.168.0.20"; USER="user"
KEY=r"C:\Users\user\.ssh\id_ed25519"
c=paramiko.SSHClient(); c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
c.connect(HOST, username=USER, key_filename=KEY, timeout=25)

def run(cmd, t=120):
    print("### $ "+cmd, flush=True)
    _,so,se=c.exec_command(cmd, timeout=t)
    out=so.read().decode("utf-8","replace"); err=se.read().decode("utf-8","replace")
    print(out.rstrip(), flush=True)
    if err.strip(): print("[e] "+err.rstrip(), flush=True)
    return out

run("echo 1 | sudo -S pkill -f FreeCAD.AppImage 2>/dev/null; echo ok")
# 启动 FreeCAD 生成配置(带 DISPLAY=:0)，setsid 脱离终端防被杀
run("echo 1 | sudo -S setsid env DISPLAY=:0 /opt/freecad/FreeCAD.AppImage > /tmp/fc_run.log 2>&1 & echo started", t=30)
time.sleep(30)
run("echo '===config dir==='; sudo ls -R /root/.config/FreeCAD 2>/dev/null | head -40")
run("echo '===user.cfg==='; sudo find /root/.config/FreeCAD -name user.cfg 2>/dev/null; sudo find /root/.config -maxdepth 3 -name '*.cfg' 2>/dev/null | head")
run("echo '===fc log tail==='; tail -c 1200 /tmp/fc_run.log | tr '\\r' '\\n' | tail -15")
run("echo '===proc==='; pgrep -fa FreeCAD.AppImage | head -2 || echo no_proc")
c.close()
