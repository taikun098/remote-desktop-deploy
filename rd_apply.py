# -*- coding: utf-8 -*-
import paramiko
HOST="192.168.0.20"; USER="user"
KEY=r"C:\Users\user\.ssh\id_ed25519"
c=paramiko.SSHClient(); c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
c.connect(HOST, username=USER, key_filename=KEY, timeout=25)
sftp=c.open_sftp()
sftp.put(r"C:\Users\user\Doubao\chats\2026-11-01\new-chat-2\rd_override.conf","/tmp/rd_override.conf")
sftp.close()
def run(cmd, t=60):
    print("### $ "+cmd, flush=True)
    _,so,se=c.exec_command(cmd, timeout=t)
    print(so.read().decode("utf-8","replace").rstrip(), flush=True)
    e=se.read().decode("utf-8","replace")
    if e.strip(): print("[e] "+e.rstrip(), flush=True)
run("echo 1 | sudo -S mkdir -p /etc/systemd/system/rustdesk.service.d && echo 1 | sudo -S cp /tmp/rd_override.conf /etc/systemd/system/rustdesk.service.d/override.conf && echo copied")
run("echo 1 | sudo -S cat /etc/systemd/system/rustdesk.service.d/override.conf")
run("echo 1 | sudo -S systemctl daemon-reload && echo 1 | sudo -S systemctl restart rustdesk; sleep 3; echo '===state==='; echo 1 | sudo -S systemctl is-enabled rustdesk; echo 1 | sudo -S systemctl is-active rustdesk")
run("echo 1 | sudo -S systemctl show rustdesk -p Restart,RestartUSec,ActiveState 2>/dev/null | head")
c.close()
