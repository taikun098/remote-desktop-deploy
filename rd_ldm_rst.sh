#!/bin/bash
echo "=== 重启 lightdm ==="
systemctl restart lightdm
echo "等 25 秒..."
sleep 25
echo "=== Xorg 进程 ==="
ps -eo pid,args | grep '[X]org'
echo "=== 活动 VT ==="
cat /sys/class/tty/tty0/active
echo "=== 会话 ==="
loginctl list-sessions
echo "=== lightdm 最近日志 ==="
journalctl -u lightdm --no-pager -n 12 2>/dev/null | tail -12
echo "=== DONE ==="
