#!/bin/bash
nohup bash -c '
W="/home/user/.steam/debian-installation/steamapps/workshop/content/431960"
DEST="/home/user/Videos/Hidamari"
mkdir -p "$DEST"
find "$W" \( -iname "*.mp4" -o -iname "*.webm" \) -size +300k 2>/dev/null \
  | grep -viE "preview|_files/|assets/|logo|button|icon" > /tmp/wp_all.txt
echo "开始拷贝 $(wc -l < /tmp/wp_all.txt) 个壁纸..." > /tmp/wp_copy.log
copied=0; skips=0
while IFS= read -r f; do
  base=$(basename "$f")
  target="$DEST/$base"; i=1
  while [ -e "$target" ]; do target="$DEST/${base%.*}_$i.${base##*.}"; i=$((i+1)); done
  if cp "$f" "$target" 2>/dev/null; then
    copied=$((copied+1)); echo "✓ $base ($(( $(stat -c%s "$f")/1048576 ))M)" >> /tmp/wp_copy.log
  else
    skips=$((skips+1)); echo "✗ 失败 $f" >> /tmp/wp_copy.log
  fi
done < /tmp/wp_all.txt
echo "完成: 拷贝 $copied, 跳过 $skips" >> /tmp/wp_copy.log
' >/dev/null 2>&1 &
echo "后台拷贝已启动 PID $!"
