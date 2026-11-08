# -*- coding: utf-8 -*-
import paramiko
HOST="192.168.0.20"; USER="user"
KEY=r"C:\Users\user\.ssh\id_ed25519"
c=paramiko.SSHClient(); c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
c.connect(HOST, username=USER, key_filename=KEY, timeout=20)
sftp=c.open_sftp()
sftp.put(r"C:\Users\user\Doubao\chats\2026-11-01\new-chat-2\vnc-start.sh","/tmp/vnc-start.sh")
sftp.close()
cmds=[
 "echo 1 | sudo -S pkill -9 fcitx5 2>/dev/null; sleep 1; echo cleaned",
 "echo 1 | sudo -S cp /tmp/vnc-start.sh /usr/local/bin/vnc-start.sh",
 "echo 1 | sudo -S systemctl restart vnc",
 "sleep 8; echo '===active==='; systemctl is-active vnc; echo '===5900==='; ss -tln | grep 5900 || echo NO5900; echo '===fcitx5==='; pgrep -fa fcitx5 || echo NO_FCITX; echo '===procs==='; pgrep -a 'Xvfb|x11vnc|xfce4-session' | head",
]
for cmd in cmds:
    print("### $ "+cmd, flush=True)
    _,so,se=c.exec_command(cmd, timeout=90)
    print(so.read().decode("utf-8","replace").rstrip(), flush=True)
    e=se.read().decode("utf-8","replace")
    if e: print("[e] "+e.rstrip(), flush=True)
c.close()
