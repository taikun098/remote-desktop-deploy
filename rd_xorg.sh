#!/bin/bash
echo "=== 两个 Xorg 的父进程/启动时间 ==="
ps -eo pid,ppid,lstart,args | grep '[X]org'
echo "=== lightdm 会话详情 ==="
loginctl session-status c5 2>/dev/null | head -8
echo "---"
loginctl session-status c6 2>/dev/null | head -8
echo "=== 残留 closing 会话的 leader ==="
for s in 141 150 154 157 159 163; do
  echo "-- $s --"; loginctl session-status $s 2>/dev/null | head -4
done
echo "=== DISPLAY :0 的 XAUTHORITY 拥有者 / 谁在 :0 ==="
ps -eo pid,user,args | grep -E 'Xorg' 
echo "=== Xorg :0 打开的文件（哪个 tty/display）==="
P0=$(ps -eo pid,args | grep '[X]org.*:0 ' | awk '{print $1}' | head -1)
echo "Xorg :0 pid=$P0"
ls -l /proc/$P0/fd 2>/dev/null | grep -iE 'tty|/dev/' | head
echo "=== DONE ==="
