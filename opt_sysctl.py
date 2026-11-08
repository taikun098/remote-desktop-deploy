# -*- coding: utf-8 -*-
import paramiko
HOST="192.168.0.20"; USER="user"
KEY=r"C:\Users\user\.ssh\id_ed25519"
c=paramiko.SSHClient(); c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
c.connect(HOST, username=USER, key_filename=KEY, timeout=25)
sftp=c.open_sftp()
sftp.put(r"C:\Users\user\Doubao\chats\2026-11-01\new-chat-2\99-vnc-tuning.conf","/tmp/99-vnc-tuning.conf")
sftp.put(r"C:\Users\user\Doubao\chats\2026-11-01\new-chat-2\99-size.conf","/tmp/99-size.conf")
sftp.close()
cmds=[
 "echo 1 | sudo -S cp /tmp/99-vnc-tuning.conf /etc/sysctl.d/99-vnc-tuning.conf && echo 1 | sudo -S sysctl --system 2>&1 | grep -E 'swappiness|vfs_cache'",
 "echo 1 | sudo -S mkdir -p /etc/systemd/journald.conf.d && echo 1 | sudo -S cp /tmp/99-size.conf /etc/systemd/journald.conf.d/99-size.conf && echo 1 | sudo -S systemctl restart systemd-journald && echo journald_ok",
 "echo '===verify==='; sysctl vm.swappiness vm.vfs_cache_pressure; echo '--- journald size ---'; journalctl --disk-usage 2>/dev/null; echo '--- files ---'; cat /etc/sysctl.d/99-vnc-tuning.conf; cat /etc/systemd/journald.conf.d/99-size.conf",
]
for cmd in cmds:
    print("### $ "+cmd, flush=True)
    _,so,se=c.exec_command(cmd, timeout=60)
    print(so.read().decode("utf-8","replace").rstrip(), flush=True)
    e=se.read().decode("utf-8","replace")
    if e: print("[e] "+e.rstrip(), flush=True)
c.close()
