#!/bin/bash
DEB=/tmp/rustdesk-1.5.0-x86_64.deb
echo "=== 下载 rustdesk 1.5.0 deb（GitHub 走代理）==="
if [ -f "$DEB" ] && [ $(stat -c%s "$DEB" 2>/dev/null || echo 0) -gt 1000000 ]; then
  echo "已有缓存 deb: $(stat -c%s $DEB) bytes"
else
  curl -sL --max-time 200 -x http://192.168.0.6:7897 -o "$DEB" "https://github.com/rustdesk/rustdesk/releases/download/1.5.0/rustdesk-1.5.0-x86_64.deb" \
    && echo "代理下载完成: $(stat -c%s $DEB) bytes" \
    || { echo "代理下载失败，试直连"; curl -sL --max-time 200 -o "$DEB" "https://github.com/rustdesk/rustdesk/releases/download/1.5.0/rustdesk-1.5.0-x86_64.deb" && echo "直连完成: $(stat -c%s $DEB) bytes"; }
fi
echo "=== deb 信息 ==="
file "$DEB" 2>/dev/null || ls -la "$DEB"
echo "=== DONE ==="
