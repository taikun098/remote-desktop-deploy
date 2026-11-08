#!/bin/bash
timeout 40 bash -c '
echo "=== 1) flatpak kill 停应用 ==="
sudo -u user flatpak kill io.github.jeffshee.Hidamari 2>&1 | head -2
sleep 2
echo "=== 2) 启动 ==="
sudo -u user env DISPLAY=:0 XDG_RUNTIME_DIR=/run/user/1000 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus \
  setsid nohup flatpak run io.github.jeffshee.Hidamari >/tmp/hid_run.log 2>&1 < /dev/null &
sleep 10
echo "--- 进程 ---"
pgrep -af "hidamari" | grep -vE "bash -c|hid_restart|flatpak kill" | head -3
echo "=== 3) 日志关键行 ==="
grep -iE "playing|player|MODE_VIDEO|error|wallpaper|video|GStreamer|gst|resolution|monitor" /tmp/hid_run.log 2>/dev/null | tail -12
echo "--- 日志尾 ---"
tail -6 /tmp/hid_run.log 2>/dev/null
echo "=== DONE ==="
'
