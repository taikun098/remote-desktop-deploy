#!/bin/bash
echo "=== 建 Steam 代理启动器 /usr/local/bin/steam-px ==="
echo 1 | sudo -S tee /usr/local/bin/steam-px >/dev/null <<'EOF'
#!/bin/bash
# Steam 走局域网代理（HTTP 192.168.0.6:7897）以加速更新
export http_proxy=http://192.168.0.6:7897
export https_proxy=http://192.168.0.6:7897
export no_proxy=localhost,127.0.0.1,192.168.0.0/16,10.1.0.0/16
exec /usr/games/steam "$@"
EOF
echo 1 | sudo -S chmod +x /usr/local/bin/steam-px
cat /usr/local/bin/steam-px
echo "=== 更新 steam.desktop Exec 指向代理启动器 ==="
echo 1 | sudo -S sed -i 's|^Exec=.*|Exec=/usr/local/bin/steam-px %U|' /usr/share/applications/steam.desktop 2>/dev/null
grep '^Exec' /usr/share/applications/steam.desktop 2>/dev/null
echo "=== 停止当前 Steam ==="
pkill -f 'steam.sh -nominidumps' 2>/dev/null
pkill -f 'ubuntu12_32/steam ' 2>/dev/null
sleep 3
pgrep -af -i steam | head -3 || echo "(steam 已停)"
echo "=== 用代理重启 Steam（:0, user）==="
export DISPLAY=:0
echo 1 | sudo -S -u user env DISPLAY=:0 XAUTHORITY=/home/user/.Xauthority \
  /usr/local/bin/steam-px -nobigpicture >/tmp/steam_px.log 2>&1 &
sleep 12
echo "--- steam 进程 ---"
pgrep -af -i 'steam' | grep -vE 'bash|grep' | head -3
echo "--- 验证代理环境是否注入 ---"
PID=$(pgrep -f 'ubuntu12_32/steam ' | head -1)
if [ -n "$PID" ]; then
  tr '\0' '\n' < /proc/$PID/environ 2>/dev/null | grep -iE 'proxy' | head
  echo "steam PID=$PID"
fi
echo "--- 启动日志 ---"
tail -8 /tmp/steam_px.log 2>/dev/null
echo "=== DONE ==="
