#!/bin/bash
timeout 40 bash -c '
sleep 6
echo "=== 截图工具 ==="
which scrot import xwd gnome-screenshot 2>/dev/null
echo "=== 截取 :0 桌面 ==="
if which scrot >/dev/null 2>&1; then
  sudo -u user env DISPLAY=:0 scrot /tmp/wp.png 2>/dev/null && echo "scrot OK"
elif which import >/dev/null 2>&1; then
  sudo -u user env DISPLAY=:0 import -window root /tmp/wp.png 2>/dev/null && echo "import OK"
else
  echo 1 | sudo -S apt-get install -y imagemagick >/tmp/apt_im.log 2>&1 && sudo -u user env DISPLAY=:0 import -window root /tmp/wp.png 2>/dev/null && echo "装了 imagemagick 并截图 OK"
fi
ls -lh /tmp/wp.png 2>/dev/null | awk "{print \$5}"
echo "=== hidamari-server 状态（看是否在播）==="
pgrep -af "hidamari-server|gst|mpv" | grep -v "bash -c" | head
echo "=== DONE ==="
'
