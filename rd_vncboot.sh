#!/bin/bash
echo "=== vnc.service 状态 ==="
systemctl status vnc.service --no-pager 2>&1 | head -15
echo "=== journalctl 最近日志 ==="
journalctl -u vnc --no-pager -n 20 2>/dev/null | tail -20
echo "=== 手动起一次 x11vnc 到 :0 ==="
timeout 6 x11vnc -display :0 -auth guess -rfbauth /etc/x11vnc.pass -rfbport 5900 -o /tmp/x11vnc_bt.log 2>&1 | tail -3
echo "--- log ---"
tail -8 /tmp/x11vnc_bt.log 2>/dev/null
echo "=== DONE ==="
