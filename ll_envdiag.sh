#!/bin/bash
echo "=== 源配置 ==="
cat /etc/apt/sources.list.d/linglong.list 2>/dev/null || echo "(无 linglong.list)"
echo "=== 仓库可达性 ==="
curl -sI --max-time 15 "https://ci.deepin.com/repo/obs/linglong:/CI:/release/xUbuntu_24.04/" 2>&1 | head -3
echo "=== 该源更新 ==="
echo 1 | sudo -S apt-get -o Acquire::http::Timeout=20 update 2>&1 | grep -iE 'linglong|错误|Err|Ign|无法|couldn|404' | head -8
echo "=== 仓库内容 ==="
curl -s --max-time 20 "https://ci.deepin.com/repo/obs/linglong:/CI:/release/xUbuntu_24.04/Packages" 2>/dev/null | grep -E '^Package:' | sort -u | head -20
echo "=== DONE ==="
