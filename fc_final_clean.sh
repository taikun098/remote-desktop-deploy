#!/bin/bash
timeout 30 bash -c '
echo "=== 删除 ~/.local/share/FreeCAD ==="
echo 1 | sudo -S rm -rf /home/user/.local/share/FreeCAD && echo "已删除 ✅"
echo "=== 清空回收站中 freecad 条目 ==="
echo 1 | sudo -S rm -f /home/user/.local/share/Trash/info/freecad.desktop.trashinfo /home/user/.local/share/Trash/files/freecad.desktop && echo "已清空回收站 freecad ✅"
echo "=== 最终全盘复核 ==="
find /opt /usr/local /usr/share /home/user -iname "*freecad*" 2>/dev/null | grep -vE "/Trash/" | head
echo "(无输出 = 彻底无残留)"
echo "=== DONE ==="
'
