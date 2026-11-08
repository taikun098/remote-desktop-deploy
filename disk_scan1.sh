#!/bin/bash
timeout 40 bash -c '
echo "=== 挂载点与挂载方式 ==="
ROOT=$(findmnt -n /dev/sdb1 -o TARGET 2>/dev/null)
echo "挂载点: $ROOT"
echo 1 | sudo -S findmnt /dev/sdb1 -o TARGET,OPTIONS 2>/dev/null
echo "=== 根目录内容（只读查看，一层）==="
ls -la "$ROOT" 2>/dev/null
echo "=== 根目录第一层里是否有 exe（maxdepth=1）==="
find "$ROOT" -maxdepth 1 -iname "*.exe" 2>/dev/null
echo "=== 根目录第一层的目录/文件统计 ==="
echo "顶层目录数: $(find "$ROOT" -maxdepth 1 -type d 2>/dev/null | wc -l)"
echo "顶层文件数: $(find "$ROOT" -maxdepth 1 -type f 2>/dev/null | wc -l)"
echo "=== 盘使用情况 ==="
df -h "$ROOT" 2>/dev/null | tail -1
echo "=== DONE ==="
'
