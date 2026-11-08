#!/bin/bash
echo "=== 杀孤儿 Xorg :0 ==="
kill -9 28001 2>&1 | head -1
sleep 3
echo "=== 等 20 秒让 lightdm 稳定 ==="
sleep 20
echo "=== Xorg 进程 ==="
ps -eo pid,args | grep '[X]org'
echo "=== 活动 VT ==="
cat /sys/class/tty/tty0/active
echo "=== 会话（只看 active/online）==="
loginctl list-sessions | grep -iE 'active|online|seat0'
echo "=== lightdm 最近日志 ==="
journalctl -u lightdm --no-pager -n 8 2>/dev/null | tail -8
echo "=== DONE ==="
