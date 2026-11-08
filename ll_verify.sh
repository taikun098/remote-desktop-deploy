#!/bin/bash
echo "=== 商店桌面入口 ==="
cat /usr/share/applications/linglong-store.desktop 2>/dev/null | grep -E 'Exec|Name|Icon'
echo "=== 商店二进制 ==="
which linglong-store 2>/dev/null
find /opt /usr -iname '*linglong*store*' -type f 2>/dev/null | grep -vE '\.desktop|\.png|\.svg' | head
echo "=== ll-cli / 玲珑环境 ==="
which ll-cli ll-box 2>/dev/null
ls /var/lib/linglong 2>/dev/null | head || echo "(无 /var/lib/linglong)"
dpkg -l 2>/dev/null | grep -iE 'linglong-(builder|repo|box)' | awk '{print $2,$3}'
echo "=== 尝试启动商店（:0 物理屏，user）==="
export DISPLAY=:0
echo 1 | sudo -S -u user env DISPLAY=:0 XAUTHORITY=/home/user/.Xauthority \
  /usr/bin/linglong-store 2>/tmp/ll_gui.log &
sleep 8
echo "进程: $(pgrep -af linglong-store | head -2)"
pgrep -f linglong-store >/dev/null && echo "商店GUI进程已启动" || echo "未启动"
pkill -f linglong-store 2>/dev/null
echo "--- GUI 日志 ---"
tail -6 /tmp/ll_gui.log 2>/dev/null
echo "=== DONE ==="
