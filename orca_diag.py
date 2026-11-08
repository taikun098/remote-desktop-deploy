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
run("echo '===X processes==='; ps -eo pid,user,cmd | grep -E '[X]org|[X]vfb' | grep -v grep")
run("echo '===desktop sessions==='; ps -eo user,pid,cmd | grep -iE 'xfce4-session|xfwm4|startxfce' | grep -v grep")
run("echo '===user GUI procs==='; ps -u user -o pid,cmd | grep -iE 'xfce|xfwm|panel|dbus' | grep -v grep | head -20")
run("echo '===lightdm auth dir==='; ls -la /var/run/lightdm/root/ 2>/dev/null || echo 'no /var/run/lightdm/root'")
run("echo '===user home Xauthority==='; ls -la /home/user/.Xauthority 2>/dev/null || echo none", sudo=True)
run("echo '===who==='; who")
run("echo '===glx on :1 (as root, lightdm auth)==='; DISPLAY=:1 XAUTHORITY=/var/run/lightdm/root/:1 glxinfo 2>&1 | grep -iE 'renderer|vendor string|direct rendering' | head -4", sudo=True)
c.close()
