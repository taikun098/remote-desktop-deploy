#!/bin/bash
timeout 60 bash -c '
W="/home/user/.steam/debian-installation/steamapps/workshop/content/431960"
DEST="/home/user/Videos/Hidamari"
echo "=== 清理刚才误拷的预览/小图 ==="
rm -f "$DEST/preview.gif" "$DEST/butterfly2b.gif" "$DEST/blueFlower.gif"
echo "=== 挑真正壁纸视频（mp4/webm, >=8M, 排除 preview/icon/thumb）==="
find "$W" \( -iname "*.mp4" -o -iname "*.webm" \) -size +8M 2>/dev/null \
  | grep -viE "preview|icon|thumb|_files|assets|logo|button" > /tmp/wp_real.txt
echo "真正壁纸候选数: $(wc -l < /tmp/wp_real.txt)"
echo "=== 随机挑 6 个并复制（去重、防同名覆盖）==="
mkdir -p "$DEST"
sort -R --random-source=/dev/urandom /tmp/wp_real.txt | head -6 | while IFS= read -r f; do
  base=$(basename "$f")
  target="$DEST/$base"
  i=1
  while [ -e "$target" ]; do target="$DEST/${base%.*}_$i.${base##*.}"; i=$((i+1)); done
  cp "$f" "$target" && printf "✓ %-60s %sM\n" "$base" "$(( $(stat -c%s "$f") / 1048576 ))"
done
echo "=== 壁纸目录最终内容 ==="
ls -lhS "$DEST" | awk "{print \$5, \$9}"
echo "=== DONE ==="
'
