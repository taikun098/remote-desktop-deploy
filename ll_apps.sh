#!/bin/bash
echo "=== ll-cli 已装应用 ==="
echo 1 | sudo -S -u user ll-cli list 2>/dev/null | head -30 || ll-cli list 2>/dev/null | head -30
echo "=== 微信/B站 相关 desktop 文件 ==="
find /usr/share/applications /home/user/.local/share/applications \
     /var/lib/linglong /home/user/.local/share/linglong -iname '*.desktop' 2>/dev/null \
  | grep -iE 'wechat|bilibili|微信|bili|weixin' | head
echo "=== linglong 应用目录结构 ==="
ls -la /home/user/.local/share/linglong/ 2>/dev/null | head
ls -la /var/lib/linglong/ 2>/dev/null | head
echo "=== 找所有 linglong 暴露的 desktop ==="
find / -path '*/linglong*' -iname '*.desktop' -not -path '*/proc/*' 2>/dev/null | head -20
echo "=== user 桌面目录 ==="
ls -la /home/user/Desktop 2>/dev/null | head || echo "(无 ~/Desktop)"
echo "=== DONE ==="
