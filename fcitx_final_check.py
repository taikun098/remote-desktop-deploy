# -*- coding: utf-8 -*-
import paramiko
HOST="192.168.0.20"; USER="user"
KEY=r"C:\Users\user\.ssh\id_ed25519"
c=paramiko.SSHClient(); c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
c.connect(HOST, username=USER, key_filename=KEY, timeout=25)
cmd = r'''
echo "=== vnc unit ==="
echo -n "active: "; systemctl is-active vnc
echo "=== procs ==="
pgrep -x fcitx5 && echo FCITX_OK || echo FCITX_GONE
pgrep -x x11vnc >/dev/null && echo X11VNC_OK
echo "=== session env (IM vars) ==="
pid=$(pgrep -x xfce4-session | head -1)
echo "session_pid=$pid"
echo 1 | sudo -S cat /proc/$pid/environ 2>/dev/null | tr "\0" "\n" | grep -E "HOME=|LANG=|GTK_IM|QT_IM|XMODIFIERS|DISPLAY=" | sed "s/^/  /"
echo "=== fcitx5-remote state (0=inactive 1=active 2=active+triggered) ==="
DISPLAY=:0 fcitx5-remote; echo "rc=$?"
echo "=== pinyin engine present ==="
ls /usr/lib/x86_64-linux-gnu/fcitx5/ | grep -i pinyin
ls ~/.config/fcitx5 2>/dev/null
'''
_,so,se=c.exec_command(cmd, timeout=60)
out=so.read().decode("utf-8","replace"); err=se.read().decode("utf-8","replace")
with open(r"C:\Users\user\Doubao\chats\2026-11-01\new-chat-2\fcitx_final.txt","w",encoding="utf-8") as f:
    f.write(out); f.write("\n[e]"+err)
print("done", flush=True)
c.close()
