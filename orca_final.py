# -*- coding: utf-8 -*-
import paramiko, time
HOST="192.168.0.20"; USER="user"
KEY=r"C:\Users\user\.ssh\id_ed25519"
c=paramiko.SSHClient(); c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
c.connect(HOST, username=USER, key_filename=KEY, timeout=25)
def run(cmd, t=60):
    print("### $ "+cmd, flush=True)
    _,so,se=c.exec_command(cmd, timeout=t)
    o=so.read().decode("utf-8","replace").rstrip()
    if o.strip(): print(o, flush=True)
    e=se.read().decode("utf-8","replace")
    if e.strip(): print("[e] "+e.rstrip(), flush=True)
# 1) 重写桌面项（tee 写 + sudo 回读）
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
stdin,_,_=c.exec_command("echo 1 | sudo -S tee /usr/share/applications/orcaslicer.desktop >/dev/null", timeout=30)
stdin.write(desktop); stdin.channel.shutdown_write()
run("echo '===menu file==='; echo 1 | sudo -S cat /usr/share/applications/orcaslicer.desktop")
# 2) 用包装脚本在 :1 实测启动
run("echo '===launch on :1==='; DISPLAY=:1 XAUTHORITY=/home/user/.Xauthority nohup /usr/local/bin/orcaslicer >/tmp/orca_run2.log 2>&1 & echo LAUNCHED; sleep 18; echo '===process==='; pgrep -f 'orca-slicer' | head; echo '===log tail==='; tail -8 /tmp/orca_run2.log 2>/dev/null")
c.close()
