#!/bin/bash
echo "=== x11vnc 是否在跑 ==="
ps -eo pid,args | grep '[x]11vnc'
ss -tlnp 2>/dev/null | grep 5900
echo "=== novnc / websockify 是否已装 ==="
dpkg -l 2>/dev/null | grep -E 'novnc|websockify' || echo "(未安装)"
which websockify 2>/dev/null || echo "(无 websockify 命令)"
ls -d /usr/share/novnc 2>/dev/null || echo "(无 /usr/share/novnc)"
echo "=== python3 / pip3 ==="
python3 --version; which pip3 pipx 2>/dev/null
echo "=== 当前在跑的 GUI 显示 ==="
cat /sys/class/tty/tty0/active 2>/dev/null
echo "=== ufw 状态（若有）==="
ufw status 2>/dev/null | head -5 || echo "(无 ufw)"
echo "=== DONE ==="
