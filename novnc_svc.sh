#!/bin/bash
set -x
# 写 systemd 服务：websockify 6080 -> localhost:5900 (x11vnc)
cat > /etc/systemd/system/novnc.service <<'EOF'
[Unit]
Description=noVNC Web Remote (websockify to x11vnc :5900)
After=network.target

[Service]
ExecStart=/usr/bin/websockify --web=/usr/share/novnc 6080 localhost:5900
Restart=always
RestartSec=3
User=root

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable novnc.service 2>&1
systemctl restart novnc.service
sleep 2
systemctl is-active novnc.service
echo "=== 6080 监听 ==="
ss -tlnp 2>/dev/null | grep 6080
echo "=== websockify 进程 ==="
ps -eo pid,args | grep '[w]ebsockify'
echo "=== 本地回环测 6080 HTTP ==="
curl -s -o /dev/null -w "HTTP %{http_code}\n" http://127.0.0.1:6080/vnc.html 2>&1 || echo "(curl 失败)"
echo "=== DONE ==="
