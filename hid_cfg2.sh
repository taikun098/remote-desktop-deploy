#!/bin/bash
timeout 30 bash -c '
V="/home/user/.var/app/io.github.jeffshee.Hidamari"
echo "=== flatpak 数据目录 ==="
find "$V" -maxdepth 3 -iname "*config*" -o -iname "*.json" 2>/dev/null | head
echo "--- 目录树 ---"
find "$V" -maxdepth 2 -type d 2>/dev/null | head -20
echo "=== config.json ==="
CFG=$(find "$V" -iname "config.json" 2>/dev/null | head -1)
echo "路径: $CFG"
[ -n "$CFG" ] && cat "$CFG"
echo "=== DONE ==="
'
