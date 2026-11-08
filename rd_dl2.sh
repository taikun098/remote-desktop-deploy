#!/bin/bash
DEB=/tmp/rustdesk-1.5.0-x86_64.deb
echo "=== 清理损坏的半安装状态 ==="
sudo -n dpkg -P rustdesk 2>&1 | grep -viE 'trigger|bamf|desktop-file|hicolor|index' | tail -5 || echo "(无包)"
sudo -n rm -f "$DEB"
echo "=== 测试代理可达性 ==="
curl -sS -m 8 -x http://192.168.0.6:7897 -o /dev/null -w "proxy http=%{http_code} size=%{size_download}\n" "https://github.com/rustdesk/rustdesk/releases/download/1.5.0/rustdesk-1.5.0-x86_64.deb" || echo "代理测试失败"
echo "=== 下载（代理，带重试）==="
curl -sS --retry 3 --retry-delay 2 -m 240 -x http://192.168.0.6:7897 -o "$DEB" "https://github.com/rustdesk/rustdesk/releases/download/1.5.0/rustdesk-1.5.0-x86_64.deb" 2>&1 | tail -3
echo "下载后: $(stat -c%s $DEB 2>/dev/null) bytes"
echo "=== 校验 deb 完整性 ==="
dpkg-deb --info "$DEB" 2>&1 | head -3 || echo "DEB 无效"
echo "=== DONE ==="
