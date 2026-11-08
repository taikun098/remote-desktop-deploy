# -*- coding: utf-8 -*-
import paramiko
HOST="192.168.0.20"; USER="user"
KEY=r"C:\Users\user\.ssh\id_ed25519"
c=paramiko.SSHClient(); c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
c.connect(HOST, username=USER, key_filename=KEY, timeout=20)

cmd = r'''
echo "=== daemon-reload + vnc unit ==="
echo 1 | sudo -S systemctl daemon-reload
echo -n "enabled: "; systemctl is-enabled vnc
echo -n "active:  "; systemctl is-active vnc
echo "=== 5900 listener ==="
ss -tln | grep 5900 || echo NO5900
echo "=== install2 (第二批) ==="
systemctl is-active vnc-install2 2>/dev/null || echo "(install2 已结束)"
echo "=== 中文语言包/字体 ==="
dpkg -l | grep -E "language-pack-zh-hans|fonts-wqy|fonts-noto-cjk" | awk "{print \$1, \$2, \$3}" | grep ^ii
echo "=== 实用软件包 ==="
for p in htop neofetch git curl wget vim nano ffmpeg gparted gnome-disk-utility firefox mousepad xfce4-terminal; do
  if dpkg -s "$p" >/dev/null 2>&1; then echo "$p OK"; else echo "$p MISSING"; fi
done
'''
_,so,se=c.exec_command(cmd, timeout=90)
out=so.read().decode("utf-8","replace"); err=se.read().decode("utf-8","replace")
with open(r"C:\Users\user\Doubao\chats\2026-11-01\new-chat-2\vnc_final_out.txt","w",encoding="utf-8") as f:
    f.write(out); f.write("\n[e]"+err)
print("written", flush=True)
c.close()
