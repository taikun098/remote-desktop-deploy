# -*- coding: utf-8 -*-
import paramiko
HOST="192.168.0.20"; USER="user"
KEY=r"C:\Users\user\.ssh\id_ed25519"
c=paramiko.SSHClient(); c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
c.connect(HOST, username=USER, key_filename=KEY, timeout=25)
sftp=c.open_sftp()
sftp.put(r"C:\Users\user\Doubao\chats\2026-11-01\new-chat-2\99-ppaproxy.conf","/tmp/99-ppaproxy.conf")
sftp.close()
cmds=[
 "echo 1 | sudo -S cp /tmp/99-ppaproxy.conf /etc/apt/apt.conf.d/99-ppaproxy.conf && echo proxy_conf_ok",
 "dpkg -s software-properties-common >/dev/null 2>&1 && echo spc_present || (echo 1 | sudo -S apt-get install -y software-properties-common >/tmp/spc.log 2>&1 && echo spc_installed)",
 "echo 1 | sudo -S add-apt-repository -y ppa:freecad-maintainers/freecad-stable 2>&1 | tail -5; echo addrepo_rc=$?",
 "echo 1 | sudo -S apt-get update 2>&1 | tail -6; echo update_rc=$?",
]
for cmd in cmds:
    print("### $ "+cmd, flush=True)
    _,so,se=c.exec_command(cmd, timeout=180)
    print(so.read().decode("utf-8","replace").rstrip(), flush=True)
    e=se.read().decode("utf-8","replace")
    if e: print("[e] "+e.rstrip(), flush=True)
c.close()
