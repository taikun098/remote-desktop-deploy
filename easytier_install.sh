#!/bin/bash
# EasyTier v2.6.4 安装脚本（在 g01 上以 sudo 运行）
set -e
VER=v2.6.4
ZIP=easytier-linux-x86_64-v2.6.4.zip
URL="https://github.com/EasyTier/EasyTier/releases/download/${VER}/${ZIP}"
echo "=== download (via proxy) ==="
cd /tmp
rm -rf easytier_dl easytier_extract "$ZIP"
mkdir -p easytier_dl
curl -x http://192.168.0.6:7897 -L -o "$ZIP" "$URL"
ls -la "$ZIP"
echo "=== extract ==="
unzip -o "$ZIP" -d easytier_extract >/dev/null
find easytier_extract -maxdepth 3 -type f | head -20
echo "=== install binaries ==="
CORE=$(find easytier_extract -name 'easytier-core' -type f | head -1)
CLI=$(find easytier_extract -name 'easytier-cli' -type f | head -1)
echo "core=$CORE  cli=$CLI"
install -m 0755 "$CORE" /usr/local/bin/easytier-core
install -m 0755 "$CLI" /usr/local/bin/easytier-cli
echo "=== verify ==="
easytier-core --version 2>&1 || /usr/local/bin/easytier-core --version 2>&1
echo "=== cap net admin for non-root usage (optional) ==="
setcap CAP_NET_ADMIN+ep /usr/local/bin/easytier-core 2>/dev/null && echo "setcap ok" || echo "setcap skipped (needs root/iproute)"
echo "=== done ==="
