#!/bin/bash
timeout 60 bash -c '
W="/home/user/.steam/debian-installation/steamapps/workshop/content/431960"
DEST="/home/user/Videos/Hidamari"
echo "=== 候选视频（含大小）==="
find "$W" \( -iname "*.mp4" -o -iname "*.webm" -o -iname "*.gif" \) -size -300M 2>/dev/null | while read f; do
  sz=$(stat -c%s "$f"); echo "$sz|$f"
done > /tmp/wp_cands.txt
echo "候选总数: $(wc -l < /tmp/wp_cands.txt)"
echo "=== 随机挑 8 个（种子固定可复现）==="
sort -R --random-source=/dev/urandom /tmp/wp_cands.txt | head -8 > /tmp/wp_pick.txt
cat /tmp/wp_pick.txt | awk -F"|" "{printf \"%.0fM  %s\\n\", \$1/1048576, \$2}"
echo "=== 复制到壁纸目录 ==="
mkdir -p "$DEST"
while IFS="|" read -r sz f; do
  cp "$f" "$DEST/" && echo "✓ $(basename "$f")"
done < /tmp/wp_pick.txt
echo "=== 壁纸目录现有内容 ==="
ls -lh "$DEST" | awk "{print \$5, \$9}"
echo "=== DONE ==="
'
