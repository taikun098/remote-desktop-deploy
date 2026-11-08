#!/bin/bash
set -x
# 1. 重写 vnc.service：x11vnc 固定到物理桌面 :0
cat > /etc/systemd/system/vnc.service <<'EOF'
[Unit]
Description=x11vnc VNC Server on physical desktop :0
After=graphical.target
Requires=graphical.target

[Service]
Type=simple
ExecStartPre=/bin/sleep 8
ExecStart=/usr/bin/x11vnc -display :0 -auth guess -forever -shared -noxdamage -repeat -rfbauth /etc/x11vnc.pass -rfbport 5900 -o /var/log/x11vnc.log
Restart=always
RestartSec=5
User=root

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable vnc.service 2>&1
systemctl restart vnc.service
sleep 3
echo "=== vnc.service 状态 ==="
systemctl is-active vnc.service

# 2. 清理 websockify 多进程，重启 novnc.service 只留一个
echo "=== 清理旧 websockify ==="
pkill -f 'websockify --web=/usr/share/novnc' 2>/dev/null
systemctl restart novnc.service
sleep 3
echo "=== novnc.service 状态 ==="
systemctl is-active novnc.service

echo "=== 5900 监听 ==="
ss -tlnp 2>/dev/null | grep 5900
echo "=== 6080 监听 ==="
ss -tlnp 2>/dev/null | grep 6080
echo "=== 本地 5900 VNC 握手（RFB banner）==="
timeout 3 bash -c 'exec 3<>/dev/tcp/127.0.0.1/5900; head -c 12 <&3 | xxd' 2>&1 || echo "(5900 失败)"
echo "=== 通过 websockify 6080 能否代理到 5900（RFB banner）==="
python3 - <<'PY'
import socket, base64
s=socket.create_connection(("127.0.0.1",6080),3)
key=base64.b64encode(b"novnc-test-abcdefghijklmnopqrstuvwxyz0123456789").decode()
req=("GET /websockify HTTP/1.1\r\nHost: 127.0.0.1:6080\r\nUpgrade: websocket\r\nConnection: Upgrade\r\nSec-WebSocket-Key: "+key+"\r\nSec-WebSocket-Version: 13\r\n\r\n")
s.sendall(req.encode())
d=s.recv(1024)
print("HTTP:", d[:120])
s.close()
PY
echo "=== DONE ==="
