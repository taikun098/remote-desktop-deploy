#!/bin/bash
timeout 40 bash -c '
echo "=== 桌面环境 ==="
echo "XDG_CURRENT_DESKTOP=$XDG_CURRENT_DESKTOP"
loginctl show-session $(loginctl 2>/dev/null | awk "/user/{print \$1;exit}") -p Type 2>/dev/null
ps -ef 2>/dev/null | grep -iE "xfce|gnome-shell|plasma|xfdesktop|cinnamon|mate" | grep -v grep | awk "{print \$8}" | sort -u | head
echo "=== 找 Wallpaper Engine 安装目录（Steam/Proton）==="
for p in /home/user/.steam/steam/steamapps/common/wallpaper_engine \
         /home/user/.local/share/Steam/steamapps/common/wallpaper_engine; do
  [ -d "$p" ] && echo "安装目录: $p" && ls "$p" | head
done
echo "=== 已下载壁纸（workshop content/431960）==="
W=$(find /home/user/.steam /home/user/.local/share/Steam -type d -path "*workshop/content/431960" 2>/dev/null | head -1)
echo "workshop 目录: $W"
if [ -n "$W" ]; then
  ls "$W" 2>/dev/null | head -20
  echo "--- 其中视频类壁纸(mp4/webm/gif)数量 ---"
  find "$W" -iname "*.mp4" -o -iname "*.webm" -o -iname "*.gif" 2>/dev/null | wc -l
  echo "--- 样例 ---"
  find "$W" \( -iname "*.mp4" -o -iname "*.webm" \) 2>/dev/null | head -5
fi
echo "=== 是否有 mpv / xwallpaper ==="
which mpv xwallpaper feh 2>/dev/null
echo "=== DONE ==="
'
