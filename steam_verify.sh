#!/bin/bash
timeout 30 bash -c '
echo "=== steam 进程 ==="
pgrep -af "ubuntu12_32/steam" | grep -v grep | head -2 || echo "(steam 未运行)"
PID=$(pgrep -f "ubuntu12_32/steam " | head -1)
if [ -z "$PID" ]; then
  echo "=== steam 未运行，用正常网络启动 ==="
  export DISPLAY=:0
  echo 1 | sudo -S -u user env DISPLAY=:0 XAUTHORITY=/home/user/.Xauthority /usr/games/steam -nobigpicture >/tmp/steam_nopx2.log 2>&1 &
  sleep 10
  PID=$(pgrep -f "ubuntu12_32/steam " | head -1)
fi
echo "steam PID=$PID"
echo "=== 确认无代理环境变量 ==="
P=$(tr "\0" "\n" < /proc/$PID/environ 2>/dev/null | grep -iE "^http_proxy|^https_proxy")
[ -z "$P" ] && echo "无代理 ✅（走正常网络）" || echo "仍含代理: $P"
echo "=== 启动日志尾部 ==="
tail -4 /tmp/steam_nopx2.log 2>/dev/null
echo "=== DONE ==="
'
