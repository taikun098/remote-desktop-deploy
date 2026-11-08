# -*- coding: utf-8 -*-
import paramiko, time
HOST="192.168.0.20"; USER="user"
KEY=r"C:\Users\user\.ssh\id_ed25519"
c=paramiko.SSHClient(); c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
c.connect(HOST, username=USER, key_filename=KEY, timeout=25)
sftp=c.open_sftp()
sftp.put(r"C:\Users\user\Doubao\chats\2026-11-01\new-chat-2\50-autologin.conf","/tmp/50-autologin.conf")
sftp.close()
def run(cmd, t=60):
    print("### $ "+cmd, flush=True)
    _,so,se=c.exec_command(cmd, timeout=t)
    print(so.read().decode("utf-8","replace").rstrip(), flush=True)
    e=se.read().decode("utf-8","replace")
    if e.strip(): print("[e] "+e.rstrip(), flush=True)
run("echo '===sessions==='; ls /usr/share/xsessions/ 2>/dev/null; echo 1 | sudo -S cat /usr/share/xsessions/xfce.desktop 2>/dev/null | grep -i '^Name=' ")
run("echo 1 | sudo -S mkdir -p /etc/lightdm/lightdm.conf.d && echo 1 | sudo -S cp /tmp/50-autologin.conf /etc/lightdm/lightdm.conf.d/50-autologin.conf && echo 1 | sudo -S cat /etc/lightdm/lightdm.conf.d/50-autologin.conf && echo applied")
run("echo 1 | sudo -S systemctl restart lightdm; sleep 4; echo 1 | sudo -S systemctl is-active lightdm")
run("echo '===verify after restart==='; echo 1 | sudo -S ps -eo pid,cmd | grep -E '[X]org|[X]vfb' | head; echo '===login procs==='; echo 1 | sudo -S ps -eo user,cmd | grep -iE 'xfce4-session|lightdm' | grep -v grep | head")
c.close()
