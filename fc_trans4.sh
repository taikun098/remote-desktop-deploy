#!/bin/bash
SQUASH=/opt/freecad/squashfs-root
echo "=== usr/share 完整目录列表 ==="
ls -la $SQUASH/usr/share/ 2>/dev/null
echo "=== usr/share 下含 freecad 的任何项 ==="
find $SQUASH/usr/share -maxdepth 2 -iname '*freecad*' 2>/dev/null
echo "=== 全部 .qm 文件（非 AddonManager / 非 qt6）==="
find $SQUASH -iname '*.qm' 2>/dev/null | grep -viE 'AddonManager|qt6' | head -20
echo "=== 资源目录里有没有 translations ==="
find $SQUASH -type d -iname 'translation*' 2>/dev/null
echo "=== DONE ==="
