#!/bin/bash
timeout 40 bash -c '
B="/var/lib/flatpak/app/io.github.jeffshee.Hidamari/x86_64/stable/cfd2f0f4de8cf84ae03c390fad791c3dfc6ae8ffdfcb3609bbf4d0e749a2bba5/files/share/hidamari/hidamari"
echo "=== data_source 处理逻辑（video）==="
grep -rn "data_source" "$B/utils.py" "$B/server.py" 2>/dev/null | head -30
echo "=== 找 MODE_VIDEO 分支怎么取文件路径 ==="
grep -rn "MODE_VIDEO" "$B/utils.py" "$B/server.py" "$B/wallpaper" 2>/dev/null | head -20
echo "=== file:// 或路径拼接样例 ==="
grep -rn "file://\|video_path\|pathlib\|Path(" "$B/utils.py" 2>/dev/null | head -20
echo "=== DONE ==="
'
