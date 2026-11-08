#!/bin/bash
SQUASH=/opt/freecad/squashfs-root
echo "=== 精确查找 FreeCAD_*.qm（文件名开头）==="
find $SQUASH -iname 'FreeCAD_*.qm' 2>/dev/null | head -30
echo "数量: $(find $SQUASH -iname 'FreeCAD_*.qm' 2>/dev/null | wc -l)"
echo "=== usr/share 结构（找 FreeCAD 数据目录）==="
ls $SQUASH/usr/share/ 2>/dev/null | grep -iE 'freecad' 
echo "--- 若有 freecad 数据目录，看 translations ---"
find $SQUASH -type d -ipath '*freecad*translations*' 2>/dev/null
find $SQUASH -type d -ipath '*freecad*' 2>/dev/null | head
echo "=== DONE ==="
