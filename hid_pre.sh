#!/bin/bash
timeout 40 bash -c '
echo "=== 1) flatpak 是否已装 ==="
which flatpak 2>/dev/null && flatpak --version 2>/dev/null || echo "flatpak 未安装"
echo "--- flathub remote ---"
flatpak remotes 2>/dev/null | head
echo "=== 2) XFCE 合成器（动态壁纸需要）==="
xfconf-query -c xfwm4 -p /general/use_compositing 2>/dev/null
echo "--- xfwm4 进程 ---"
pgrep -af xfwm4 | head -1
echo "=== 3) 挑一个壁纸视频（workshop 里第一个 mp4）==="
W="/home/user/.steam/debian-installation/steamapps/workshop/content/431960"
VID=$(find "$W" -iname "*.mp4" -o -iname "*.webm" 2>/dev/null | head -1)
echo "候选: $VID"
ls -lh "$VID" 2>/dev/null | awk "{print \$5, \$9}"
echo "=== 4) mpv（Hidamari 播放后端）==="
which mpv 2>/dev/null || echo "mpv 未装（flatpak 版自带，不装也行）"
echo "=== DONE ==="
'
