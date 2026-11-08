#!/bin/bash
timeout 40 bash -c '
echo "=== 1) 应用权限 ==="
flatpak info --show-permissions io.github.jeffshee.Hidamari 2>/dev/null | head -20
echo "=== 2) 源码里的 mode 枚举（Hidamari 是 Python 应用）==="
SRC=$(find /var/lib/flatpak/app/io.github.jeffshee.Hidamari -name "*.py" 2>/dev/null | head -1)
echo "样例源码: $SRC"
if [ -n "$SRC" ]; then
  grep -rhoE "MODE_[A-Z_]+" "$(dirname "$SRC")" 2>/dev/null | sort -u | head -20
fi
echo "=== 3) data_source 如何写（找样例）==="
grep -rl "data_source" /var/lib/flatpak/app/io.github.jeffshee.Hidamari 2>/dev/null | head -2
echo "=== DONE ==="
'
