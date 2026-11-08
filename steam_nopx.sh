#!/bin/bash
timeout 40 bash -c '
echo "=== 还原 steam.desktop Exec ==="
echo 1 | sudo -S sed -i "s|^Exec=.*|Exec=/usr/games/steam %U|" /usr/share/applications/steam.desktop 2>/dev/null
grep "^Exec" /usr/share/applications/steam.desktop 2>/dev/null
echo "=== 删除代理启动器 ==="
echo 1 | sudo -S rm -f /usr/local/bin/steam-px 2>/dev/null && echo "已删除 steam-px"
echo "=== 停止当前带代理的 Steam ==="
pkill -f "steam.sh -nominidumps" 2>/dev/null
pkill -f "ubuntu12_32/steam " 2>/dev/null
sleep 3
pgrep -af -i "ubuntu12_32/steam" | head -2 || echo "(steam 已停)"
echo "=== 用正常网络重启 Steam（:0, user）==="
export DISPLAY=:0
echo 1 | sudo -S -u user env DISPLAY=:0 XAUTHORITY=/home/user/.Xauthority \
  /usr/games/steam -nobigpicture >/tmp/steam_nopx.log 2>&1 &
sleep 10
echo "--- steam 进程 ---"
pgrep -af "ubuntu12_32/steam" | grep -v grep | head -2
echo "--- 确认无 proxy 环境变量 ---"
PID=$(pgrep -f "ubuntu12_32/steam " | head -1)
if [ -n "$PID" ]; then
  echo "steam PID=$PID"
  P=$(tr "\0" "\n" < /proc/$PID/environ 2>/dev/null | grep -iE "^http_proxy|^https_proxy" | head)
  [ -z "$P" ] && echo "无代理环境变量 ✅（走正常网络）" || echo "仍含代理: $P"
fi
echo "=== DONE ==="
'
