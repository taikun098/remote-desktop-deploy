#!/bin/bash
set -x
echo "=== 1. 停 rustdesk ==="
systemctl stop rustdesk.service
sleep 1
echo "=== 2. 终止残留 closing 会话 ==="
for s in 141 150 154 157 159 163; do
  loginctl terminate-session $s 2>&1 | head -1
done
echo "=== 3. 终止 greeter 会话 c6 并杀 Xorg :0 ==="
loginctl terminate-session c6 2>&1 | head -1
sleep 2
pkill -f 'Xorg.*:0 ' 2>&1 | head -1
sleep 2
echo "=== 4. 检查 Xorg 是否只剩 :1 ==="
ps -eo pid,args | grep '[X]org' | head
echo "=== 5. 物理屏切回桌面 vt7 ==="
chvt 7
sleep 1
echo "active vt: $(cat /sys/class/tty/tty0/active)"
echo "=== 6. 会话列表 ==="
loginctl list-sessions
echo "=== 7. rustdesk --server 是否还活着 ==="
ps -eo pid,args | grep '[r]ustdesk --server' | head
echo "=== DONE ==="
