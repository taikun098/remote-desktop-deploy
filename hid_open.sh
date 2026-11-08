#!/bin/bash
timeout 40 bash -c '
echo "=== 检查是否已运行 ==="
pgrep -af "hidamari" | grep -vE "bash -c|wp_fill|hid_restart" | head -3
echo "=== 启动 Hidamari（:0 桌面）==="
sudo -u user env DISPLAY=:0 XDG_RUNTIME_DIR=/run/user/1000 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus \
  setsid nohup flatpak run io.github.jeffshee.Hidamari >/tmp/hid_run.log 2>&1 < /dev/null &
sleep 8
echo "--- 进程 ---"
pgrep -af "hidamari|hidamari-server" | grep -vE "bash -c|flatpak kill" | head -3
echo "--- 日志尾 ---"
tail -4 /tmp/hid_run.log 2>/dev/null
echo "=== DONE ==="
'
