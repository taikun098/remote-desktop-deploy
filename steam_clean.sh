#!/bin/bash
timeout 40 bash -c '
echo "=== 彻底停止所有 steam 进程 ==="
echo 1 | sudo -S pkill -f "steam" 2>/dev/null
sleep 4
echo 1 | sudo -S pkill -9 -f "steam" 2>/dev/null
sleep 2
pgrep -af "steam" | grep -viE "grep|/tmp/" | head || echo "(所有 steam 已停)"
echo "=== 清理可能残留的代理配置 ==="
# 删除 Steam 自身可能记住的代理设置项（env 为主，config 兜底）
echo 1 | sudo -S -u user sed -i "/^.*Proxy.*=/d;/^.*proxy.*=/d" /home/user/.steam/steam/registry.vdf 2>/dev/null || true
echo "registry.vdf 中 proxy 残留: $(grep -ci proxy /home/user/.steam/steam/registry.vdf 2>/dev/null || echo 0)"
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
echo "--- 确认无代理 ---"
P=$(tr "\0" "\n" < /proc/$PID/environ 2>/dev/null | grep -iE "^http_proxy|^https_proxy")
[ -z "$P" ] && echo "无代理环境变量 ✅（走正常网络）" || echo "仍含代理: $P"
echo "=== DONE ==="
'
