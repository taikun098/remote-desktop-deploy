#!/bin/bash
timeout 30 bash -c '
echo "=== 安装日志尾部 ==="
tail -15 /tmp/hid_install.log 2>/dev/null
echo "=== 是否已装好 ==="
flatpak list 2>/dev/null | grep -i hidamari
echo "--- 运行中的安装进程 ---"
pgrep -af "flatpak.*Hidamari" | head -1 || echo "(安装进程已结束)"
echo "=== DONE ==="
'
