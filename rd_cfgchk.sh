#!/bin/bash
echo "=== user RustDesk2.toml 全文 ==="
cat /home/user/.config/rustdesk/RustDesk2.toml 2>/dev/null
echo "=== root RustDesk2.toml 全文 ==="
cat /root/.config/rustdesk/RustDesk2.toml 2>/dev/null
echo "=== 实际 --server 进程 pid/线程/连接 ==="
P=$(ps -eo pid,args | grep -E '/usr/share/rustdesk/rustdesk --server' | grep -v grep | awk '{print $1}' | head -1)
echo "server pid=$P"
cat /proc/$P/status 2>/dev/null | grep -E 'State|Threads|VmRSS'
echo "--- 该进程到 yc 的连接 ---"
ss -tnp 2>/dev/null | grep -E "36.102.85.112|445800773" 
echo "--- 该进程全部 socket ---"
ls -l /proc/$P/fd 2>/dev/null | grep -c socket
echo "=== DONE ==="
