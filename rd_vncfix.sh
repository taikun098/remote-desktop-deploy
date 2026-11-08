#!/bin/bash
set -x
cat > /etc/systemd/system/vnc.service <<'EOF'
[Unit]
Description=x11vnc VNC Server on physical desktop :0
After=graphical.target

[Service]
Type=simple
ExecStartPre=/bin/sleep 8
ExecStart=/usr/bin/x11vnc -display :0 -auth guess -forever -shared -noxdamage -repeat -rfbauth /etc/x11vnc.pass -rfbport 5900 -o /var/log/x11vnc.log
Restart=always
RestartSec=5
User=root

[Install]
WantedBy=graphical.target
EOF
systemctl daemon-reload
systemctl enable vnc.service 2>&1
systemctl restart vnc.service
sleep 3
echo "=== 状态 ==="
systemctl is-active vnc.service
echo "=== 5900 监听 ==="
ss -tlnp 2>/dev/null | grep 5900 || echo "5900 未监听"
echo "=== 验证没有 ordering cycle ==="
systemd-analyze verify /etc/systemd/system/vnc.service 2>&1 | head || echo "(无警告)"
echo "=== DONE ==="
