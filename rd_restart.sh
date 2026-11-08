#!/bin/bash
set -e
echo "=== vainfo（lightdm render 权限）==="
timeout 10 sudo -u lightdm vainfo 2>&1 | grep -E 'Driver version|VAProfile.*H264.*Enc|VAProfile.*HEVC.*Enc|error|Error|Cannot' | head -8 || echo "(vainfo 无/失败)"
echo "=== 重启 rustdesk ==="
systemctl restart rustdesk.service
echo "等 50 秒（hwcodec 初始化需要 GPU 检测）..."
sleep 50
echo "=== 21116 TCP/UDP ==="
ss -tlnp 2>/dev/null | grep 21116 || echo "(21116 TCP 未监听)"
ss -ulnp 2>/dev/null | grep 21116 || echo "(21116 UDP 未监听)"
echo "=== rustdesk 全部监听 ==="
ss -tlnp 2>/dev/null | grep rustdesk || echo "(无 tcp)"
ss -ulnp 2>/dev/null | grep rustdesk || echo "(无 udp)"
echo "=== --server 日志最新 20 行 ==="
sudo -u lightdm tail -20 /var/lib/lightdm/.local/share/logs/RustDesk/server/rustdesk_rCURRENT.log 2>/dev/null
echo "=== 状态 ==="
systemctl is-active rustdesk.service
echo "=== DONE ==="
