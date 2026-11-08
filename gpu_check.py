# -*- coding: utf-8 -*-
import paramiko, time
HOST="192.168.0.20"; USER="user"
KEY=r"C:\Users\user\.ssh\id_ed25519"
c=paramiko.SSHClient(); c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
c.connect(HOST, username=USER, key_filename=KEY, timeout=25)
def run(cmd, t=50, sudo=False):
    if sudo: cmd="echo 1 | sudo -S bash -c '%s'"%cmd.replace("'","'\\''")
    print("### $ "+cmd, flush=True)
    _,so,se=c.exec_command(cmd, timeout=t)
    o=so.read().decode("utf-8","replace").rstrip()
    if o.strip(): print(o, flush=True)
    e=se.read().decode("utf-8","replace")
    if e.strip(): print("[e] "+e.rstrip(), flush=True)
# 1) 拿 user 桌面会话的 DISPLAY/XAUTHORITY
run("echo '===session env==='; pid=$(pgrep -u user -f xfce4-session | head -1); echo pid=\$pid; tr '\\0' '\\n' < /proc/\$pid/environ | grep -E '^(DISPLAY|XAUTHORITY)='", sudo=False)
# 2) GPU 渲染验证（物理屏）
run("echo '===glxinfo on :1 (sudo, lightdm auth)==='; DISPLAY=:1 XAUTHORITY=/var/run/lightdm/root/:1 glxinfo 2>&1 | grep -iE 'OpenGL renderer|OpenGL vendor|direct rendering' | head -4", sudo=True)
c.close()
