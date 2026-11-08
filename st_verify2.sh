#!/bin/bash
timeout 25 bash -c '
echo "=== steam 进程 ==="
pgrep -af "ubuntu12_32/steam " | grep -v grep | head -1
PID=$(pgrep -f "ubuntu12_32/steam " | head -1)
echo "steam PID=$PID"
echo "=== 环境变量中的代理 ==="
P=$(tr "\0" "\n" < /proc/$PID/environ 2>/dev/null | grep -iE "^http_proxy|^https_proxy|^no_proxy")
[ -z "$P" ] && echo "无任何代理环境变量 ✅（走正常网络）" || echo "代理: $P"
echo "=== 对照：系统中残留 proxy env（/etc/environment）==="
grep -iE "proxy" /etc/environment 2>/dev/null || echo "(/etc/environment 无 proxy)"
echo "=== DONE ==="
'
