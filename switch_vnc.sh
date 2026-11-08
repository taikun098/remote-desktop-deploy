#!/bin/bash
# 把 VNC 从 Xvfb :0 切到物理屏 :1（lightdm 自动登录的 user GPU 桌面）
set -e
echo "=== step: stop old vnc ==="
systemctl stop vnc 2>/dev/null || true
sleep 2
echo "=== step: kill Xvfb :0 + root xfce stack ==="
XPID=$(pgrep -f '^Xvfb :0' | head -1)
echo "Xvfb pid=$XPID"
[ -n "$XPID" ] && kill "$XPID" 2>/dev/null || true
sleep 2
pkill -u root -f 'xfce4-session' 2>/dev/null || true
pkill -u root -f 'xfwm4 --display :0' 2>/dev/null || true
pkill -u root -f 'fcitx5' 2>/dev/null || true
sleep 1
echo "=== step: write physical vnc script ==="
cat > /usr/local/bin/vnc-physical.sh <<'EOF'
#!/bin/bash
# VNC 共享物理屏 :1（带 GPU 加速的 user 桌面）
export DISPLAY=:1
exec /usr/bin/x11vnc -display :1 -auth guess -forever -shared -noxdamage -repeat \
    -rfbauth /etc/x11vnc.pass -rfbport 5900 -o /var/log/x11vnc.log
EOF
chmod 755 /usr/local/bin/vnc-physical.sh
echo "=== step: update vnc.service ==="
cat > /etc/systemd/system/vnc.service <<'EOF'
[Unit]
Description=VNC Remote Desktop (shares physical display :1, GPU)
After=network.target lightdm.service

[Service]
Type=simple
ExecStart=/usr/local/bin/vnc-physical.sh
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
echo "=== step: start new vnc ==="
systemctl start vnc
sleep 4
echo "=== verify ==="
systemctl is-active vnc
echo "--- x11vnc log ---"
cat /var/log/x11vnc.log 2>/dev/null | tail -15
echo "--- port 5900 ---"
ss -tlnp | grep 5900 || echo "5900 NOT listening"
echo "--- X processes now ---"
ps -eo pid,user,cmd | grep -E '[X]org -core :1|[X]vfb' | grep -v grep
