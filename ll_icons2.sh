#!/bin/bash
timeout 40 bash -c '
SRC=/var/lib/linglong/entries/apps/share/applications
echo "=== linglong 应用 desktop 源目录 ==="
echo 1 | sudo -S ls "$SRC" 2>/dev/null | head -30
echo "=== 同步到 ~/Desktop ==="
echo 1 | sudo -S mkdir -p /home/user/Desktop
cnt=0
for f in $(echo 1 | sudo -S ls "$SRC" 2>/dev/null | grep "\.desktop$"); do
  base="$f"
  if [ ! -e "/home/user/Desktop/$base" ]; then
    echo 1 | sudo -S cp "$SRC/$base" "/home/user/Desktop/$base" 2>/dev/null
    echo 1 | sudo -S chmod +x "/home/user/Desktop/$base" 2>/dev/null
    echo 1 | sudo -S chown user:user "/home/user/Desktop/$base" 2>/dev/null
    echo "添加: $base"
    cnt=$((cnt+1))
  else
    echo "已有: $base"
  fi
done
echo "共新增 $cnt 个"
echo "=== 桌面 desktop 最终 ==="
ls -la /home/user/Desktop/*.desktop 2>/dev/null | awk "{print \$5,\$9}"
echo "=== 微信 desktop 内容（确认能启动）==="
cat /home/user/Desktop/wechat.desktop 2>/dev/null | grep -E "Name|Exec" | head -4
echo "=== DONE ==="
'
