#!/bin/bash
timeout 60 bash -c '
W="/home/user/.steam/debian-installation/steamapps/workshop/content/431960"
echo "=== 逐步排查：mp4/webm/gif 总数 ==="
find "$W" \( -iname "*.mp4" -o -iname "*.webm" -o -iname "*.gif" \) 2>/dev/null | wc -l
echo "--- 去掉预览后 ---"
find "$W" \( -iname "*.mp4" -o -iname "*.webm" -o -iname "*.gif" \) 2>/dev/null | grep -viE "preview|_files/|assets/|logo|button|icon" | wc -l
echo "--- 去预览且 >300K ---"
find "$W" \( -iname "*.mp4" -o -iname "*.webm" -o -iname "*.gif" \) -size +300k 2>/dev/null | grep -viE "preview|_files/|assets/|logo|button|icon" | wc -l
echo "--- 去预览且 >300K 且非 gif(只 mp4/webm) ---"
find "$W" \( -iname "*.mp4" -o -iname "*.webm" \) -size +300k 2>/dev/null | grep -viE "preview|_files/|assets/|logo|button|icon" | wc -l
echo "=== DONE ==="
'
