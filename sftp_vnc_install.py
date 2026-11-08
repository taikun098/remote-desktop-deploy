# -*- coding: utf-8 -*-
import paramiko
HOST="192.168.0.20"; USER="user"
KEY=r"C:\Users\user\.ssh\id_ed25519"
FILES=[
 (r"C:\Users\user\Doubao\chats\2026-11-01\new-chat-2\vnc-start.sh", "/tmp/vnc-start.sh"),
 (r"C:\Users\user\Doubao\chats\2026-11-01\new-chat-2\vnc.service", "/tmp/vnc.service"),
]
c=paramiko.SSHClient(); c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
c.connect(HOST, username=USER, key_filename=KEY, timeout=20)
sftp=c.open_sftp()
for l,r in FILES:
    sftp.put(l,r); print("uploaded", r, flush=True)
sftp.close()

cmds = [
 "echo 1 | sudo -S cp /tmp/vnc-start.sh /usr/local/bin/vnc-start.sh && echo 1 | sudo -S chmod 755 /usr/local/bin/vnc-start.sh",
 "echo 1 | sudo -S cp /tmp/vnc.service /etc/systemd/system/vnc.service",
 "echo 1 | sudo -S systemctl daemon-reload",
 "echo 1 | sudo -S systemctl enable vnc && echo 1 | sudo -S systemctl start vnc",
 "sleep 4; echo '===status==='; systemctl is-active vnc; echo '===port 5900==='; ss -tlnp | grep 5900; echo '===procs==='; pgrep -a 'Xvfb|x11vnc|xfce4-session'",
]
for cmd in cmds:
    print("### $ "+cmd, flush=True)
    _,so,se=c.exec_command(cmd, timeout=60)
    o=so.read().decode("utf-8","replace"); e=se.read().decode("utf-8","replace")
    if o: print(o.rstrip(), flush=True)
    if e: print("[e] "+e.rstrip(), flush=True)
c.close()
