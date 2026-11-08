#!/bin/bash
timeout 40 bash -c '
D="/media/user/完成_50cc_09346"
echo "=== kuwan/ 一层 ==="
ls -la "$D/kuwan" 2>/dev/null | head -40
echo ""
echo "=== Playnite/ 一层 ==="
ls -la "$D/Playnite" 2>/dev/null | head -40
echo "=== 游戏可执行文件抽样（kuwan 下前几个目录）==="
for g in $(ls "$D/kuwan" 2>/dev/null | head -8); do
  [ -d "$D/kuwan/$g" ] || continue
  exe=$(find "$D/kuwan/$g" -maxdepth 2 -iname "*.exe" 2>/dev/null | head -3)
  echo "--- $g ---"; echo "$exe" | head -3
done
echo "=== DONE ==="
'
