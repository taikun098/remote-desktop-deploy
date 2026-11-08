#!/bin/bash
timeout 30 bash -c '
echo "=== 残留 desktop 内容 ==="
cat /usr/share/applications/freecad.desktop 2>/dev/null | grep -E "^Name|^Exec|^Icon" | head
echo "=== 删除残留 ==="
echo 1 | sudo -S rm -f /usr/share/applications/freecad.desktop && echo "已删除 freecad.desktop ✅"
echo "=== 清理可能残留的图标 ==="
find /usr/share/icons /usr/share/pixmaps -iname "*freecad*" 2>/dev/null | head
echo 1 | sudo -S find /usr/share/icons /usr/share/pixmaps -iname "*freecad*" -delete 2>/dev/null
echo "=== 全盘再扫一遍 freecad 残留 ==="
find /usr/share /opt /usr/local /home/user/Desktop /home/user/.config /home/user/.local/share -iname "*freecad*" 2>/dev/null | head
echo "(以上无输出即无残留)"
echo "=== DONE ==="
'
