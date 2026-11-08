#!/bin/bash
echo "=== 现在 21116 ==="
ss -tlnp 2>/dev/null | grep 21116 || echo "TCP未监听"
ss -ulnp 2>/dev/null | grep 21116 || echo "UDP未监听"
echo "=== 当前配置 key（脱敏看前8位）==="
grep -E "^key" /home/user/.config/rustdesk/RustDesk2.toml 2>/dev/null | sed 's/= .*/= <前8位>:'"$(grep -E '^key' /home/user/.config/rustdesk/RustDesk2.toml 2>/dev/null | sed 's/.*= .//; s/.$//' | cut -c1-8)/"'/'
echo "=== rendezvous 配置 ==="
grep -E "rendezvous|custom-rendezvous" /home/user/.config/rustdesk/RustDesk2.toml 2>/dev/null
echo "=== rustdesk --server 进程状态 ==="
P=$(ps -eo pid,args | grep 'rustdesk --server' | grep -v grep | awk '{print $1}' | head -1)
echo "pid=$P"
cat /proc/$P/status 2>/dev/null | grep -E 'State|Threads|VmRSS'
echo "=== 完整日志行数 & 最后的 register/hbbs 相关行 ==="
LOG=/home/user/.local/share/logs/RustDesk/server/rustdesk_rCURRENT.log
wc -l < $LOG 2>/dev/null
grep -iE 'register|hbbs|refused|reject|error|denied|key' $LOG 2>/dev/null | tail -15
echo "=== 日志最新 6 行 ==="
tail -6 $LOG 2>/dev/null
echo "=== DONE ==="
