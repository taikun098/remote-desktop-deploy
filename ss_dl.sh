#!/bin/bash
timeout 120 bash -c '
export http_proxy=http://192.168.0.6:7897 https_proxy=http://192.168.0.6:7897
URL="https://github.com/LizardByte/Sunshine/releases/download/v2025.628.4510/sunshine-ubuntu-24.04-amd64.deb"
echo "=== 0) 代理连通性测试 ==="
curl -fsS -m 15 -o /dev/null -w "proxy->github 状态: %{http_code}\n" https://github.com 2>&1 | tail -1 || echo "github 直连代理测试失败"
echo "=== 1) 代理下载重试（--retry）==="
curl -fSL --retry 4 --retry-delay 3 -m 240 -o /tmp/sunshine.deb "$URL" 2>&1 | tail -3
if [ -s /tmp/sunshine.deb ] && [ $(stat -c%s /tmp/sunshine.deb) -gt 5000000 ]; then
  echo "下载成功: $(du -h /tmp/sunshine.deb | cut -f1)"
else
  echo "代理下载失败，尝试镜像 gh-proxy..."
  curl -fSL --retry 2 -m 240 -o /tmp/sunshine.deb "https://gh-proxy.com/$URL" 2>&1 | tail -3
  [ -s /tmp/sunshine.deb ] && echo "镜像下载成功: $(du -h /tmp/sunshine.deb | cut -f1)" || echo "镜像也失败"
fi
echo "=== 校验文件大小 ==="
stat -c "%n %s 字节" /tmp/sunshine.deb 2>/dev/null
echo "=== DONE ==="
'
