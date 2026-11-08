#!/bin/bash
set -e
echo "=== 把 lightdm 加入 video,render 组 ==="
usermod -aG video,render lightdm
echo "=== 确认 ==="
id lightdm
echo "=== 重启 rustdesk ==="
systemctl restart rustdesk.service
echo "重启完成，等 25 秒初始化...（跳过 hwcodec 卡点需要时间）"
sleep 25
echo "=== 21116? ==="
ss -tlnp 2>/dev/null | grep 21116 || echo "(21116 TCP 未监听)"
ss -ulnp 2>/dev/null | grep 21116 || echo "(21116 UDP 未监听)"
echo "=== --server 日志最新 12 行 ==="
sudo -u lightdm tail -12 /var/lib/lightdm/.local/share/logs/RustDesk/server/rustdesk_rCURRENT.log 2>/dev/null
echo "=== 状态 ==="
systemctl is-active rustdesk.service
echo "=== DONE ==="
