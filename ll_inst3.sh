#!/bin/bash
cd /tmp
ls -lh llstore.deb
echo "=== 安装 deb（自动装玲珑环境 ll-cli 等）==="
echo 1 | sudo -S env DEBIAN_FRONTEND=noninteractive apt-get install -y ./llstore.deb 2>&1 | tail -25
echo "=== 安装结果 ==="
dpkg -l 2>/dev/null | grep -iE 'linglong' | awk '{print $2,$3}'
which ll-cli 2>/dev/null && echo "ll-cli: $(ll-cli --version 2>/dev/null | head -1)" || echo "(无 ll-cli)"
echo "=== 桌面入口 ==="
find /usr/share/applications /home/user/.local/share/applications -iname '*linglong*' 2>/dev/null | head
echo "=== DONE ==="
