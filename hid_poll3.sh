#!/bin/bash
timeout 30 bash -c '
echo "=== 安装日志尾部 ==="
tail -6 /tmp/hid_install.log 2>/dev/null
echo "=== 已装应用 ==="
flatpak list --app 2>/dev/null | grep -i hidamari
echo "--- 安装进程 ---"
pgrep -af "flatpak.*Hidamari" | head -1 || echo "(安装已结束)"
echo "=== DONE ==="
'
