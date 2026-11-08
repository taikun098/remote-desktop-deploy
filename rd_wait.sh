#!/bin/bash
SPID=$(ps -eo pid,args | grep 'rustdesk --server' | grep -v grep | awk '{print $1}' | tail -1)
echo "server pid=$SPID"
ps -o pid,stat,wchan,etime -p "$SPID" 2>/dev/null
echo "=== 线程栈摘要（哪些线程在等）==="
cat /proc/$SPID/status 2>/dev/null | grep -E 'State|Threads'
echo "=== 日志是否还在增长 / 最后修改 ==="
ls -la --time-style=+%H:%M:%S /var/lib/lightdm/.local/share/logs/RustDesk/server/rustdesk_rCURRENT.log
echo "=== 等 40 秒再看 21116 ==="
sleep 40
ss -tlnp 2>/dev/null | grep 21116 || echo "(21116 TCP 仍未监听)"
ss -ulnp 2>/dev/null | grep 21116 || echo "(21116 UDP 仍未监听)"
echo "=== 日志最新 6 行 ==="
sudo -u lightdm tail -6 /var/lib/lightdm/.local/share/logs/RustDesk/server/rustdesk_rCURRENT.log 2>/dev/null
echo "=== DONE ==="
