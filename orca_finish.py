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
# 1) 更新包装脚本：DISPLAY=:1 + XAUTHORITY
wrapper="""#!/bin/bash
export DISPLAY=:1
export XAUTHORITY=/home/user/.Xauthority
exec /opt/orcaslicer/OrcaSlicer.AppImage \"$@\"
"""
sftp=c.open_sftp()
with sftp.open("/tmp/orca_wrapper.sh","w") as f: f.write(wrapper)
sftp.close()
run("echo 1 | sudo -S cp /tmp/orca_wrapper.sh /usr/local/bin/orcaslicer && echo 1 | sudo -S chmod 755 /usr/local/bin/orcaslicer && cat /usr/local/bin/orcaslicer")
# 2) 建菜单项（xfce 应用菜单可点）
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
with sftp.open("/tmp/orcaslicer.desktop","w") as f: f.write(desktop)
sftp.close()
run("echo 1 | sudo -S cp /tmp/orcaslicer.desktop /usr/share/applications/orcaslicer.desktop && echo MENU_OK")
# 3) 在 :1 上实测启动（正确授权），数秒后确认存活再关闭
run("DISPLAY=:1 XAUTHORITY=/home/user/.Xauthority nohup /opt/orcaslicer/OrcaSlicer.AppImage --appimage-extract-and-run >/tmp/orca_run.log 2>&1 & echo LAUNCHED; sleep 15; echo '===alive?==='; pgrep -f 'orca-slicer' | head; echo '---log---'; tail -6 /tmp/orca_run.log 2>/dev/null", sudo=False)
c.close()
