# -*- coding: utf-8 -*-
import paramiko
HOST="192.168.0.20"; USER="user"
KEY=r"C:\Users\user\.ssh\id_ed25519"
c=paramiko.SSHClient(); c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
c.connect(HOST, username=USER, key_filename=KEY, timeout=25)
def run(cmd, t=40, sudo=False):
    if sudo: cmd="echo 1 | sudo -S bash -c '%s'"%cmd.replace("'","'\\''")
    print("### $ "+cmd, flush=True)
    _,so,se=c.exec_command(cmd, timeout=t)
    o=so.read().decode("utf-8","replace").rstrip()
    if o.strip(): print(o, flush=True)
    e=se.read().decode("utf-8","replace")
    if e.strip(): print("[e] "+e.rstrip(), flush=True)
run("echo '===uptime/boot==='; uptime; systemd-analyze | head -3; who -b")
run("echo '===session exes==='; which startxfce4 xfce4-session xfce4-panel; ls -la /usr/bin/xfce4-session /usr/bin/startxfce4 2>&1 | head")
run("echo '===xfce.desktop==='; cat /usr/share/xsessions/xfce.desktop", sudo=True)
run("echo '===greeter==='; cat /etc/lightdm/lightdm.conf.d/*.conf 2>/dev/null; echo '---main conf seat---'; grep -E 'greeter-session|user-session|autologin' /etc/lightdm/lightdm.conf 2>/dev/null | grep -v '^#' | head")
run("echo '===auth file now==='; ls -la /var/run/lightdm/ 2>/dev/null; find /var/run/lightdm -name ':1' 2>/dev/null; find /run -maxdepth 3 -name 'X1' 2>/dev/null")
run("echo '===user login shell home==='; getent passwd user; ls -la /home/user/ | head -20")
run("echo '===X sockets==='; ls -la /tmp/.X11-unix/ 2>/dev/null")
c.close()
