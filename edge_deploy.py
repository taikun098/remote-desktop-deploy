# -*- coding: utf-8 -*-
import paramiko
HOST="192.168.0.20"; USER="user"
KEY=r"C:\Users\user\.ssh\id_ed25519"
c=paramiko.SSHClient(); c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
c.connect(HOST, username=USER, key_filename=KEY, timeout=25)
sftp=c.open_sftp()
sftp.put(r"C:\Users\user\Doubao\chats\2026-11-01\new-chat-2\edge_wrapper.sh","/tmp/edge_wrapper.sh")
sftp.close()
cmds=[
 "echo 1 | sudo -S cp /tmp/edge_wrapper.sh /usr/local/bin/edge && echo 1 | sudo -S chmod 755 /usr/local/bin/edge && echo edge_wrapper_ok",
 "ls -l /usr/local/bin/edge",
 "echo 1 | sudo -S add-apt-repository -r -y ppa:freecad-maintainers/freecad-stable 2>&1 | tail -2; echo rm_ppa_rc=$?",
 "echo '===FreeCAD dl==='; cat /tmp/fc_dl.log 2>/dev/null || echo still_downloading; ls -la /opt/freecad/ 2>/dev/null",
 "echo '===freecad unit==='; systemctl is-active opt-freecad 2>/dev/null || echo FC_DOWNLOAD_DONE",
]
for cmd in cmds:
    print("### $ "+cmd, flush=True)
    _,so,se=c.exec_command(cmd, timeout=120)
    print(so.read().decode("utf-8","replace").rstrip(), flush=True)
    e=se.read().decode("utf-8","replace")
    if e: print("[e] "+e.rstrip(), flush=True)
c.close()
