#!/bin/bash
echo "等 40 秒（hwcodec 初始化）..."
sleep 40
echo "=== 21116 TCP/UDP ==="
ss -tlnp 2>/dev/null | grep 21116 || echo "(21116 TCP 未监听)"
ss -ulnp 2>/dev/null | grep 21116 || echo "(21116 UDP 未监听)"
echo "=== rustdesk 全部 TCP/UDP 监听 ==="
ss -tlnp 2>/dev/null | grep rustdesk || echo "(无 tcp)"
ss -ulnp 2>/dev/null | grep rustdesk || echo "(无 udp)"
echo "=== --server 日志最新 15 行 ==="
sudo -u lightdm tail -15 /var/lib/lightdm/.local/share/logs/RustDesk/server/rustdesk_rCURRENT.log 2>/dev/null
echo "=== 状态 ==="
systemctl is-active rustdesk.service
echo "=== DONE ==="
