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
# 用 sudo -n tee（免密，stdin 直接给内容）
stdin,_,_=c.exec_command("sudo -n tee /usr/share/applications/orcaslicer.desktop >/dev/null", timeout=30)
stdin.write(desktop); stdin.channel.shutdown_write()
run("echo '===menu==='; sudo -n cat /usr/share/applications/orcaslicer.desktop")
# 清掉测试实例
run("echo '===kill test instance==='; sudo -n pkill -f 'orca-slicer'; sleep 2; pgrep -f 'orca-slicer' | wc -l")
c.close()
