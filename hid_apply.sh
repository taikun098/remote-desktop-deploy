#!/bin/bash
timeout 60 bash -c '
VID="/home/user/.steam/debian-installation/steamapps/workshop/content/431960/2522553111/world of warcraft.mp4"
CFG="/home/user/.var/app/io.github.jeffshee.Hidamari/config/hidamari/config.json"
echo "=== 1) 复制壁纸到应用可访问目录 ==="
mkdir -p /home/user/Videos/Hidamari
cp "$VID" "/home/user/Videos/Hidamari/world_of_warcraft.mp4" && echo "已复制 ✅" && ls -lh "/home/user/Videos/Hidamari/world_of_warcraft.mp4" | awk "{print \$5}"
echo "=== 2) 写配置（MODE_VIDEO + 该壁纸）==="
sudo -u user python3 - <<PYEOF
import json
cfg = {
  "version": 4,
  "mode": "MODE_VIDEO",
  "data_source": {
     "HDMI-A-1": "/home/user/Videos/Hidamari/world_of_warcraft.mp4",
     "Default": "/home/user/Videos/Hidamari/world_of_warcraft.mp4"
  },
  "is_mute": False,
  "audio_volume": 50,
  "is_static_wallpaper": False,
  "static_wallpaper_blur_radius": 5,
  "is_pause_when_maximized": True,
  "is_mute_when_maximized": False,
  "fade_duration_sec": 1.5,
  "fade_interval": 0.1,
  "is_show_systray": False,
  "is_first_time": False
}
with open("$CFG","w") as f: json.dump(cfg, f, indent=3)
print("配置已写入")
PYEOF
echo "=== 3) 重启 Hidamari ==="
pkill -f "io.github.jeffshee.Hidamari" 2>/dev/null
pkill -f "hidamari" 2>/dev/null
sleep 2
sudo -u user env DISPLAY=:0 XDG_RUNTIME_DIR=/run/user/1000 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus \
  nohup flatpak run io.github.jeffshee.Hidamari >/tmp/hid_run.log 2>&1 &
sleep 8
echo "--- 进程 ---"
pgrep -af "hidamari" | grep -v "bash -c" | head -2
echo "=== 4) 运行日志（找播放器/错误）==="
grep -iE "playing|player|video|error|wallpaper|MODE" /tmp/hid_run.log 2>/dev/null | tail -12
echo "--- 日志最后几行 ---"
tail -6 /tmp/hid_run.log 2>/dev/null
echo "=== DONE ==="
'
