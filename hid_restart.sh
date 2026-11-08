#!/bin/bash
timeout 45 bash -c '
echo "=== 1) 按 PID 停掉旧 Hidamari ==="
OLD=$(pgrep -f "flatpak run io.github.jeffshee.Hidamari" | grep -v $$)
[ -n "$OLD" ] && echo 1 | sudo -S kill $OLD 2>/dev/null && echo "已停 flatpak 进程: $OLD"
BW=$(pgrep -f "bwrap.*hidamari" | grep -v $$)
[ -n "$BW" ] && echo 1 | sudo -S kill $BW 2>/dev/null && echo "已停 bwrap: $BW"
sleep 2
echo "剩余 hidamari 进程: $(pgrep -cf hidamari || echo 0)"
echo "=== 2) 确认配置已就位 ==="
cat /home/user/.var/app/io.github.jeffshee.Hidamari/config/hidamari/config.json | python3 -c "import sys,json;d=json.load(sys.stdin);print(\"mode=\",d[\"mode\"]);print(\"src=\",d[\"data_source\"])"
echo "=== 3) 启动 Hidamari ==="
sudo -u user env DISPLAY=:0 XDG_RUNTIME_DIR=/run/user/1000 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus \
  nohup flatpak run io.github.jeffshee.Hidamari >/tmp/hid_run.log 2>&1 &
sleep 9
echo "--- 进程 ---"
pgrep -af "hidamari" | grep -v "bash -c" | head -2
echo "=== 4) 日志（找播放状态）==="
grep -iE "playing|player|MODE_VIDEO|error|wallpaper|video|GStreamer|gst" /tmp/hid_run.log 2>/dev/null | tail -10
echo "--- 日志尾 ---"
tail -5 /tmp/hid_run.log 2>/dev/null
echo "=== DONE ==="
'
