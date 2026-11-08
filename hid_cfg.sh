#!/bin/bash
timeout 30 bash -c '
echo "=== 找 Hidamari 配置文件 ==="
find /home/user/.config /home/user/.local/share -ipath "*hidamari*" 2>/dev/null
echo "--- 直接列 ~/.config 下相关 ---"
ls -la /home/user/.config/ 2>/dev/null | grep -i hidamari
echo "--- 读取 config.json（若存在）---"
for f in /home/user/.config/Hidamari/config.json /home/user/.config/hidamari/config.json; do
  [ -f "$f" ] && echo "== $f ==" && cat "$f"
done
echo "=== 桌面图标/状态（Hidamari 是否已设为壁纸）==="
echo "（无壁纸模式=还没设）"
echo "=== DONE ==="
'
