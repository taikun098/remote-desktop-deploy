#!/bin/bash
timeout 40 bash -c '
echo "=== linglong entries/applications 内容 ==="
echo 1 | sudo -S ls -la /var/lib/linglong/entries/applications/ 2>/dev/null | head -30
echo "=== 找 wechat desktop ==="
W=$(find /var/lib/linglong/entries -iname "*wechat*.desktop" 2>/dev/null | head -1)
echo "wechat desktop: $W"
echo "=== 现有 ~/Desktop ==="
ls -la /home/user/Desktop/ 2>/dev/null
echo "=== 把 linglong 各应用 desktop 同步到桌面 ==="
echo 1 | sudo -S mkdir -p /home/user/Desktop
cnt=0
for f in /var/lib/linglong/entries/applications/*.desktop; do
  [ -e "$f" ] || continue
  base=$(basename "$f")
  # 若桌面已有同名则跳过，否则复制（保留可执行）
  if [ ! -e "/home/user/Desktop/$base" ]; then
    echo 1 | sudo -S cp "$f" "/home/user/Desktop/$base" 2>/dev/null
    echo 1 | sudo -S chmod +x "/home/user/Desktop/$base" 2>/dev/null
    echo 1 | sudo -S chown user:user "/home/user/Desktop/$base" 2>/dev/null
    echo "添加: $base"
    cnt=$((cnt+1))
  else
    echo "已有: $base"
  fi
done
echo "共新增 $cnt 个"
echo "=== 最终桌面 desktop ==="
ls -la /home/user/Desktop/*.desktop 2>/dev/null
echo "=== DONE ==="
'
