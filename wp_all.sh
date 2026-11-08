#!/bin/bash
timeout 45 bash -c '
echo "=== 1) 撤掉开机自启 ==="
rm -f /home/user/.config/autostart/hidamari.desktop
[ -f /home/user/.config/autostart/hidamari.desktop ] && echo "还在" || echo "自启已撤 ✅"
echo "=== 2) 统计要拷贝的壁纸（mp4/webm/gif，排除预览小图）==="
W="/home/user/.steam/debian-installation/steamapps/workshop/content/431960"
find "$W" \( -iname "*.mp4" -o -iname "*.webm" -o -iname "*.gif" \) -size +300K 2>/dev/null \
  | grep -viE "preview|icon|thumb|_files|logo|button|assets/" > /tmp/wp_all.txt
echo "壁纸文件数: $(wc -l < /tmp/wp_all.txt)"
echo "总大小: $(awk "{s+=\$1}END{printf \"%.1fG\\n\", s/1073741824}" <(while read f; do stat -c%s "$f"; done < /tmp/wp_all.txt))"
echo "=== 3) /home 剩余空间 ==="
df -h /home | awk "NR==2{print \"可用:\", \$4}"
echo "=== DONE ==="
'
