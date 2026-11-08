#!/bin/bash
set -x
cat > /etc/systemd/system/vnc.service <<'EOF'
[Unit]
Description=x11vnc VNC Server on physical desktop :0
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/x11vnc -display :0 -auth guess -forever -shared -noxdamage -repeat -rfbauth /etc/x11vnc.pass -rfbport 5900 -o /var/log/x11vnc.log
Restart=always
RestartSec=5
User=root

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl disable vnc.service 2>&1   # 清掉旧的 graphical.target.wants 软链
systemctl enable vnc.service 2>&1    # 生成 multi-user.target.wants
systemctl restart vnc.service
sleep 8
echo "=== 状态 ==="
systemctl is-active vnc.service
echo "=== 5900 监听 ==="
ss -tlnp 2>/dev/null | grep 5900 || echo "5900 未监听"
echo "=== 有无循环依赖 ==="
systemd-analyze verify /etc/systemd/system/vnc.service 2>&1 | head || echo "(clean)"
echo "=== 软链 ==="
ls -l /etc/systemd/system/*.wants/vnc.service 2>/dev/null
echo "=== DONE ==="
