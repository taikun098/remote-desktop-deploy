#!/bin/bash
echo "=== rustdesk --server 真实 pid ==="
P=$(ps -eo pid,args | grep -E '/usr/share/rustdesk/rustdesk --server' | grep -v grep | awk '{print $1}' | head -1)
echo "server pid=$P"
echo "=== 该 pid 状态/线程 ==="
cat /proc/$P/status 2>/dev/null | grep -E 'State|Threads'
echo "=== 该 pid 到 yc(36.102.85.112) 的连接（TCP+UDP）==="
ss -tnp 2>/dev/null | grep "36.102.85.112" 
echo "--- UDP ---"
ss -unp 2>/dev/null | grep "36.102.85.112"
echo "=== 该 pid 所有监听端口 ==="
ss -tlnp 2>/dev/null | grep "pid=$P" 
ss -ulnp 2>/dev/null | grep "pid=$P"
echo "=== 日志是否还在增长 ==="
LOG=/home/user/.local/share/logs/RustDesk/server/rustdesk_rCURRENT.log
stat -c 'size=%s mtime=%y' $LOG
echo "=== 日志尾部 15 行 ==="
tail -15 $LOG
echo "=== 全部监听 TCP（有无 21116 或新增）==="
ss -tlnp 2>/dev/null | grep -E '2111|Listen|0.0.0.0' | head -20
echo "=== DONE ==="
