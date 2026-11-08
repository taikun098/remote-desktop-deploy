#!/bin/bash
timeout 40 bash -c '
echo "=== linglong entries 结构 ==="
find /var/lib/linglong/entries -maxdepth 3 2>/dev/null | head -40
echo "=== 找 wechat/bilibili 的 desktop ==="
find /var/lib/linglong -iname "*.desktop" 2>/dev/null | grep -iE "wechat|weixin|微信|bili" | head
echo "=== entries/applications 内容 ==="
ls -la /var/lib/linglong/entries/applications/ 2>/dev/null | head -20
echo "=== 桌面现有 desktop 对比 ==="
ls -la /home/user/Desktop/*.desktop 2>/dev/null
echo "=== bilibili.desktop(桌面) 内容 ==="
cat /home/user/Desktop/bilibili.desktop 2>/dev/null
echo "=== DONE ==="
'
