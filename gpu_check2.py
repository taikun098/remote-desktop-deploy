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
# 1) 正确读 user 会话的 DISPLAY/XAUTHORITY（单条 bash，变量本地展开）
cmd='echo "===session env==="; pid=$(pgrep -u user -f xfce4-session | head -1); echo "pid=$pid"; tr "\\0" "\\n" < /proc/$pid/environ | grep -E "^(DISPLAY|XAUTHORITY)="'
run(cmd, sudo=False)
# 2) 装 mesa-utils 拿 glxinfo（脱离 SSH，防断开）
run("echo 1 | sudo -S systemd-run --collect --unit=glx-install apt-get -y install mesa-utils >/dev/null 2>&1; echo launched")
for _ in range(20):
    time.sleep(5)
    _,so,_=c.exec_command("systemctl is-active glx-install 2>/dev/null", timeout=15)
    if so.read().decode().strip() != "active":
        print("glx-install done", flush=True); break
# 3) 验证 GPU 渲染（物理屏 :1，root+lightdm auth）
run("echo 1 | sudo -S bash -c 'DISPLAY=:1 XAUTHORITY=/var/run/lightdm/root/:1 glxinfo 2>&1 | grep -iE \"OpenGL renderer|OpenGL vendor|direct rendering\" | head -4'", sudo=False)
c.close()
