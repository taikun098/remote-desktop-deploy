#!/bin/bash
timeout 40 bash -c '
echo "=== 收集 steam PID 并停止 ==="
PIDS=$(pgrep -f "ubuntu12_32/steam|steam.sh" )
echo "steam PIDs: $PIDS"
for p in $PIDS; do echo 1 | sudo -S kill "$p" 2>/dev/null; done
sleep 4
PIDS2=$(pgrep -f "ubuntu12_32/steam|steam.sh")
for p in $PIDS2; do echo 1 | sudo -S kill -9 "$p" 2>/dev/null; done
sleep 2
echo "剩余 steam: $(pgrep -f "ubuntu12_32/steam|steam.sh" | wc -l)"
echo "=== 用 env -i 干净环境重启 Steam ==="
export DISPLAY=:0
echo 1 | sudo -S -u user env -i \
  HOME=/home/user DISPLAY=:0 XAUTHORITY=/home/user/.Xauthority \
  USER=user PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
  /usr/games/steam -nobigpicture >/tmp/steam_clean.log 2>&1 &
sleep 12
echo "--- steam 进程 ---"
pgrep -af "ubuntu12_32/steam" | grep -v grep | head -2
PID=$(pgrep -f "ubuntu12_32/steam " | head -1)
echo "steam PID=$PID"
P=$(tr "\0" "\n" < /proc/$PID/environ 2>/dev/null | grep -iE "^http_proxy|^https_proxy")
[ -z "$P" ] && echo "无代理环境变量 ✅（走正常网络）" || echo "仍含代理: $P"
echo "=== DONE ==="
'
