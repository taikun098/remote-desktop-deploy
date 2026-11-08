# -*- coding: utf-8 -*-
import paramiko
HOST="192.168.0.20"; USER="user"
KEY=r"C:\Users\user\.ssh\id_ed25519"
c=paramiko.SSHClient(); c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
c.connect(HOST, username=USER, key_filename=KEY, timeout=25)
cmd = r'''
echo "=== vnc unit ==="
echo -n "active: "; systemctl is-active vnc
echo -n "enabled: "; systemctl is-enabled vnc
echo "=== 5900 ==="
ss -tln | grep 5900 || echo NO5900
echo "=== procs ==="
pgrep -a fcitx5 | head
pgrep -a Xvfb | head -1
pgrep -a x11vnc | head -1
echo "=== IM env in session (xfce4-session) ==="
pid=$(pgrep -x xfce4-session | head -1)
echo "pid=$pid"
if [ -n "$pid" ]; then tr "\0" "\n" < /proc/$pid/environ 2>/dev/null | grep -E "IM_MODULE|XMODIFIERS|LANG|LC_ALL" ; fi
'''
_,so,se=c.exec_command(cmd, timeout=60)
out=so.read().decode("utf-8","replace"); err=se.read().decode("utf-8","replace")
with open(r"C:\Users\user\Doubao\chats\2026-11-01\new-chat-2\fcitx_verify.txt","w",encoding="utf-8") as f:
    f.write(out); f.write("\n[e]"+err)
print("done", flush=True)
c.close()
