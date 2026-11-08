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
run("echo '===effective lightdm config (seat)==='; lightdm --show-config 2>/dev/null | grep -iE 'autologin|user-session|greeter|seat' || echo 'show-config 不可用'", sudo=True)
run("echo '===lightdm conf.d files==='; ls -la /etc/lightdm/lightdm.conf.d/ 2>/dev/null; cat /etc/lightdm/lightdm.conf.d/*.conf 2>/dev/null")
run("echo '===journal lightdm since boot==='; journalctl -u lightdm --no-pager -b 2>&1 | grep -iE 'autologin|session|user|greeter|failed|error' | tail -40")
run("echo '===nopasswdlogin group==='; grep nopasswdlogin /etc/group; id user | tr ',' '\n' | grep nopasswdlogin")
run("echo '===xsessions==='; ls /usr/share/xsessions/")
c.close()
