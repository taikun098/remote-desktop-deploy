#!/bin/bash
SQUASH=/opt/freecad/squashfs-root
echo "=== locale 里是否有 FreeCAD/freecad 的 .mo ==="
find $SQUASH/usr/share/locale -iname '*.mo' 2>/dev/null | grep -iE 'freecad' | head
echo "--- 所有 .mo 中带 freecad 的（含路径）数量 ---"
find $SQUASH/usr/share/locale -iname '*freecad*.mo' 2>/dev/null | wc -l
echo "=== zh_CN locale 目录 ==="
ls $SQUASH/usr/share/locale/zh_CN/LC_MESSAGES/ 2>/dev/null | head
echo "=== 检查 FreeCAD 1.1 用的是 gettext 还是 qm（看 Gui 资源）==="
find $SQUASH/usr/share/Gui -maxdepth 2 2>/dev/null | head
find $SQUASH -ipath '*Gui*translations*' 2>/dev/null | head
echo "=== 检查是否有 freecad.mo 或 FreeCAD.mo 全局 ==="
find $SQUASH -iname 'freecad*.mo' 2>/dev/null | head
echo "=== DONE ==="
