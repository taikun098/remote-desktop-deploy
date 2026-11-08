#!/bin/bash
LOG=/root/.local/share/logs/RustDesk/service/rustdesk_rCURRENT.log
echo "=== 日志文件 ==="
ls -la /root/.local/share/logs/RustDesk/service/ 2>/dev/null
echo "=== 日志尾部（rendezvous/server/connect/error/relay）==="
sudo -n tail -80 "$LOG" 2>/dev/null | grep -iE 'rendezvous|server|connect|relay|2111|error|fail|register|key|net|ID|Online' | tail -40
echo "=== 全部最近 30 行 ==="
sudo -n tail -30 "$LOG" 2>/dev/null
echo "=== DONE ==="
