#!/bin/bash
timeout 40 bash -c '
echo "=== 系统默认 locale ==="
echo 1 | sudo -S localectl status 2>/dev/null | grep -iE "LANG|Language" | head
echo "--- 已装中文语言包 ---"
locale -a 2>/dev/null | grep -i "zh_CN" | head
echo "=== user 会话环境里的 LANG ==="
ps -ef 2>/dev/null | grep -E "xfce4-session|linglong-store" | grep -v grep | head
echo "=== 商店进程及其 LANG 环境 ==="
PID=$(pgrep -f "linglong-store" | head -1)
echo "商店 PID: $PID"
if [ -n "$PID" ]; then tr "\0" "\n" < /proc/$PID/environ 2>/dev/null | grep -E "^(LANG|LC_ALL|LC_MESSAGES|HOME)=" ; fi
echo "=== 商店桌面入口 ==="
D=$(find /var/lib/linglong/entries/apps/share/applications /usr/share/applications ~/.local/share/applications -iname "*linglong-store*" 2>/dev/null | head -1)
echo "desktop: $D"
[ -n "$D" ] && cat "$D" | grep -iE "Exec|Name"
echo "=== linglong store 配置（语言项）==="
find /home/user/.linglong /home/user/.config -path "*linglong*store*" -name "*.conf" -o -name "*.json" 2>/dev/null | head -5
echo "=== DONE ==="
'
