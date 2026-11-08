#!/bin/bash
echo "=== 全部 rustdesk 进程 ==="
ps -eo pid,ppid,user,args | grep '[r]ustdesk'
echo "=== --server 真实进程(2083) socket ==="
ss -tlnp 2>/dev/null | grep -E '2083|2111'
ss -ulnp 2>/dev/null | grep -E '2083|2111'
echo "=== --server(2083) 状态 ==="
cat /proc/2083/status 2>/dev/null | grep -E 'State|Threads'
echo "=== journal 中 rustdesk 相关报错 ==="
journalctl --no-pager -u rustdesk --since "09:50" 2>/dev/null | tail -25
echo "=== 是否已有 --server 最新日志（09:57 后有没有新增）==="
LOG=/home/user/.local/share/logs/RustDesk/server/rustdesk_rCURRENT.log
stat -c '大小=%s 修改=%y' $LOG 2>/dev/null
echo "=== DONE ==="
