#!/bin/bash
DEB=/tmp/rustdesk-1.5.0-x86_64.deb
URL="https://github.com/rustdesk/rustdesk/releases/download/1.5.0/rustdesk-1.5.0-x86_64.deb"
sudo -n rm -f "$DEB"
echo "=== 下载（代理 + 跟随重定向 + 重试）==="
curl -sSL --retry 3 --retry-delay 2 -m 300 -x http://192.168.0.6:7897 -o "$DEB" "$URL" 2>&1 | tail -5
SZ=$(stat -c%s "$DEB" 2>/dev/null || echo 0)
echo "代理下载后: $SZ bytes"
if [ "$SZ" -lt 1000000 ]; then
  echo "代理下载异常，改用直连+跟随重定向"
  sudo -n rm -f "$DEB"
  curl -sSL --retry 3 --retry-delay 2 -m 300 -o "$DEB" "$URL" 2>&1 | tail -5
  echo "直连下载后: $(stat -c%s $DEB 2>/dev/null) bytes"
fi
echo "=== 校验 ==="
dpkg-deb --info "$DEB" 2>&1 | grep -E 'Package|Version|Architecture|Size' || echo "DEB 无效"
echo "=== DONE ==="
