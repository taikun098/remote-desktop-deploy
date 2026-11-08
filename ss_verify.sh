#!/bin/bash
timeout 40 bash -c '
echo "=== 1) Web 管理界面可访问性 ==="
curl -s -o /dev/null -w "http://192.168.0.20:47990 -> HTTP %{http_code}\n" -m 10 http://127.0.0.1:47990 2>&1 | tail -1
echo "=== 2) sunshine 日志：编码器/显示/DRM ==="
echo 1 | sudo -S journalctl --user -u sunshine --no-pager -n 60 2>/dev/null | grep -iE "encoder|vaapi|drm|/dev/dri|display|output|resolution|ffmpeg|nv|amf" | tail -12
echo "=== 3) 配置位置与关键项 ==="
CFG=$(find /home/user/.config /home/user/.local/share -iname "sunshine*" -maxdepth 3 2>/dev/null | head -3)
echo "$CFG"
echo "--- sunshine.conf 关键项 ---"
find /home/user/.config/sunshine /home/user/.var/app /home/user/.local/share -name "sunshine.conf" 2>/dev/null | head -1 | xargs -I{} grep -iE "output_name|encoder|address_family|port|display" {} 2>/dev/null | head
echo "=== 4) 通过 EasyTier/内网可到达的地址提示 ==="
ip -4 addr show 2>/dev/null | grep -E "inet " | grep -v "127.0.0.1" | awk "{print \$2}"
echo "=== DONE ==="
'
