#!/bin/bash
SQUASH=/opt/freecad/squashfs-root
echo "=== 所有 translations 目录 ==="
find $SQUASH -type d -iname 'translations' 2>/dev/null
echo "=== 查找 FreeCAD 主翻译（文件名含 FreeCAD 的 qm）==="
find $SQUASH -iname '*.qm' 2>/dev/null | grep -iE 'FreeCAD.*\.qm' | head -20
echo "=== 所有含 zh/CN 的 qm 完整列表 ==="
find $SQUASH -iname '*.qm' 2>/dev/null | grep -iE 'zh' | wc -l
find $SQUASH -iname '*.qm' 2>/dev/null | grep -iE 'zh' | head -40
echo "=== DONE ==="
