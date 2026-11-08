#!/bin/bash
cd /tmp
URL="https://github.com/HanHan666666/flutter-linglong-store/releases/download/v3.7.0/linglong-store_3.7.0_amd64.deb"
EXPECT="E8DECF181BB82A7F9E15A1B6579498798DE79239B2A435453ABF7FE97E8BF8A9"
echo "=== 下载（代理）==="
curl -fL -x http://192.168.0.6:7897 --retry 4 --retry-delay 3 -o llstore.deb "$URL" || echo DOWNLOAD_FAIL
ls -lh llstore.deb
GOT=$(sha256sum llstore.deb | awk '{print $1}')
echo "本地sha: $GOT"
if [ "$GOT" != "$EXPECT" ]; then echo "SHA_MISMATCH"; exit 1; fi
echo "SHA_OK"
echo "=== 安装 deb（自动装玲珑环境）==="
echo 1 | sudo -S env DEBIAN_FRONTEND=noninteractive apt-get install -y ./llstore.deb 2>&1 | tail -20
echo "=== 安装结果 ==="
dpkg -l 2>/dev/null | grep -iE 'linglong' | awk '{print $2,$3}'
which ll-cli 2>/dev/null && ll-cli --version 2>/dev/null | head -2 || echo "(无 ll-cli)"
echo "=== 桌面入口 ==="
find /usr/share/applications /home/user/.local/share/applications -iname '*linglong*' 2>/dev/null | head
grep -h 'Name=' $(find /usr/share/applications -iname '*linglong*' 2>/dev/null | head -1) 2>/dev/null
echo "=== DONE ==="
