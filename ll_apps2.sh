#!/bin/bash
timeout 40 bash -c '
echo "=== ll-cli 已装应用 ==="
ll-cli list 2>/dev/null | head -40
echo "=== 用户/系统 applications 目录 ==="
ls /home/user/.local/share/applications/ 2>/dev/null | head -40
echo "--- 系统 ---"
ls /usr/share/applications/ 2>/dev/null | grep -iE "wechat|bili|weixin|微信" | head
echo "=== linglong 应用目录 ==="
ls -la /home/user/.local/share/linglong/ 2>/dev/null | head -15
echo "--- /var/lib/linglong ---"
ls -la /var/lib/linglong/ 2>/dev/null | head -15
echo "=== linglong 应用内 desktop（用户+系统，限深）==="
find /home/user/.local/share/linglong /var/lib/linglong -maxdepth 4 -iname "*.desktop" 2>/dev/null | head -20
echo "=== 桌面目录 ==="
ls -la /home/user/Desktop 2>/dev/null | head -6 || echo "(无 ~/Desktop)"
echo "=== DONE ==="
'
