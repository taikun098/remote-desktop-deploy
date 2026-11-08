#!/bin/bash
echo "=== 探查 deepin OBS release 仓库目录 ==="
curl -s --max-time 20 "https://ci.deepin.com/repo/obs/linglong:/CI:/release/" 2>/dev/null | grep -oP 'href="[^"]*/"' | head -40
echo "=== 试常见 xUbuntu 路径 ==="
for p in xUbuntu_24.04 Ubuntu_24.04 xUbuntu_24.04/ 24.04; do
  code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 12 "https://ci.deepin.com/repo/obs/linglong:/CI:/release/$p/" 2>/dev/null)
  echo "$p -> $code"
done
echo "=== Gitee 玲珑源 / 官方仓库查找 ==="
curl -s --max-time 15 "https://api.github.com/repos/OpenAtom-Linyaps/sig-linyaps-simple-store" 2>/dev/null | grep -oP '"full_name":\s*"\K[^"]+' || echo "(sig仓库不可查)"
echo "=== DONE ==="
