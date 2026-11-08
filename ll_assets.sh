#!/bin/bash
echo "=== 查 GitHub 最新 release 的 amd64 deb 资产 ==="
curl -x http://192.168.0.6:7897 -s --max-time 30 https://api.github.com/repos/HanHan666666/flutter-linglong-store/releases/latest 2>/dev/null \
  | grep -oP '"tag_name":\s*"\K[^"]+' | head -1
curl -x http://192.168.0.6:7897 -s --max-time 30 https://api.github.com/repos/HanHan666666/flutter-linglong-store/releases/latest 2>/dev/null \
  | grep -oP '"browser_download_url":\s*"\K[^"]+' | grep -iE '\.deb$' | head
echo "=== 也查 OpenAtom sig 仓库 ==="
curl -x http://192.168.0.6:7897 -s --max-time 30 https://api.github.com/repos/OpenAtom-Linyaps/sig-linyaps-simple-store/releases/latest 2>/dev/null \
  | grep -oP '"browser_download_url":\s*"\K[^"]+' | grep -iE '\.deb$' | head
echo "=== DONE ==="
