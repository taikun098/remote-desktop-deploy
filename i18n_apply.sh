#!/bin/bash
set -x
# 重启图形会话以应用中文 locale + fcitx5
systemctl restart lightdm
sleep 18
echo "=== 桌面是否回来 ==="
echo "活动终端: $(cat /sys/class/tty/tty0/active)"
ps -eo pid,user,args | grep '[X]org :0' | head -1
who 2>/dev/null
echo "=== fcitx5 进程是否在跑 ==="
ps -eo pid,user,args | grep '[f]citx5' | head -3
echo "=== 会话 locale ==="
sudo -u user bash -lc 'locale | head -4' 2>/dev/null
echo "=== 服务状态 ==="
for s in rustdesk novnc vnc; do printf "%s:%s " "$s" "$(systemctl is-active $s)"; done; echo
echo "=== DONE ==="
