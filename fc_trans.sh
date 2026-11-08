#!/bin/bash
SQUASH=/opt/freecad/squashfs-root
echo "=== 查找 FreeCAD 翻译文件位置 ==="
find $SQUASH -iname '*.qm' 2>/dev/null | head -20
echo "--- 按目录看 ---"
find $SQUASH -type d -iname '*transl*' 2>/dev/null | head
echo "=== 确认 zh 中文翻译是否存在 ==="
find $SQUASH -iname '*.qm' 2>/dev/null | grep -iE 'zh|Chinese' | head
echo "=== 建立 freecadcmd 命令链接 ==="
ln -sf $SQUASH/usr/bin/freecadcmd /usr/local/bin/freecadcmd
which freecadcmd && echo "freecadcmd 已建链"
echo "=== 现有 desktop 菜单项 ==="
find /usr/share/applications -iname '*freecad*' 2>/dev/null
echo "=== DONE ==="
