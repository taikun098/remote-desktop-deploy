#!/bin/bash
echo "=== 玲珑商店 + 环境最终状态 ==="
dpkg -l 2>/dev/null | grep -iE 'linglong' | awk '{print $2"  "$3}'
echo "--- ll-cli ---"
ll-cli --version 2>/dev/null | head -1
echo "--- 桌面入口 ---"
grep -m1 'Name\[zh_CN\]' /usr/share/applications/linglong-store.desktop
echo "=== 二次验证商店 GUI 启动（:0）==="
export DISPLAY=:0
echo 1 | sudo -S -u user env DISPLAY=:0 XAUTHORITY=/home/user/.Xauthority /usr/bin/linglong-store 2>/tmp/ll_gui2.log &
sleep 7
pgrep -f linglong_store >/dev/null && echo "商店GUI正常启动 ✅" || echo "启动失败"
pkill -f linglong_store 2>/dev/null
echo "=== 源(玲珑) ==="
cat /etc/apt/sources.list.d/linglong.list
echo "=== DONE ==="
