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
# 1) 更新自动登录配置：加 autologin-session
conf="""[Seat:*]
autologin-user=user
autologin-user-timeout=0
autologin-session=xfce
user-session=xfce
"""
sftp=c.open_sftp()
with sftp.open("/tmp/50-autologin.conf","w") as f: f.write(conf)
sftp.close()
run("echo 1 | sudo -S cp /tmp/50-autologin.conf /etc/lightdm/lightdm.conf.d/50-autologin.conf && cat /etc/lightdm/lightdm.conf.d/50-autologin.conf")
# 2) 彻底停掉 lightdm，清掉陈旧的授权目录，再全新启动
run("echo 1 | sudo -S systemctl stop lightdm; sleep 2; echo 1 | sudo -S rm -rf /var/run/lightdm/root; echo 'stopped+cleaned'", sudo=False)
time.sleep(3)
run("echo 1 | sudo -S systemctl start lightdm; echo started", sudo=False)
time.sleep(18)
# 3) 验证
run("echo '===auth file==='; ls -la /var/run/lightdm/root/ 2>/dev/null || echo 'NO AUTH FILE'", sudo=True)
run("echo '===Xorg :1==='; ps -eo pid,user,cmd | grep -E '[X]org -core :1' | grep -v grep")
run("echo '===user desktop session==='; ps -u user -o pid,cmd | grep -iE 'xfce4-session|xfwm4|xfce4-panel' | grep -v grep || echo 'NO user session'")
run("echo '===lightdm recent==='; journalctl -u lightdm --no-pager -n 15 2>&1 | tail -15", sudo=True)
c.close()
