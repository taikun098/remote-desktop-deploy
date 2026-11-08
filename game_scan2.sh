#!/bin/bash
timeout 40 bash -c '
D="/media/user/完成_50cc_09346"
for base in "$D/kuwan" "$D/Playnite"; do
  echo "======== $base/0000 ========"
  ls -la "$base/0000" 2>/dev/null | head -60
  echo ""
done
echo "=== Playnite/0000 内游戏目录名（前 40 个，只看名字）==="
ls "$D/Playnite/0000" 2>/dev/null | head -40
echo ""
echo "=== kuwan/0000 内目录名（前 40 个）==="
ls "$D/kuwan/0000" 2>/dev/null | head -40
echo "=== DONE ==="
'
