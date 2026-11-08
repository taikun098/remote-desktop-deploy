#!/bin/bash
echo 1 | sudo -S systemd-run --unit=ll-env2 --collect \
  bash -c '
    set -x
    echo "deb [trusted=yes] https://ci.deepin.com/repo/obs/linglong:/CI:/release/Ubuntu_24.04/ ./" | sudo tee /etc/apt/sources.list.d/linglong.list
    sudo apt-get update 2>&1 | grep -iE "linglong|Err|错误|无法" | head -5
    echo 1 | sudo -S env DEBIAN_FRONTEND=noninteractive apt-get install -y linglong-bin linglong-installer 2>&1 | tail -12
    echo "=== LLENV2_DONE ==="
  ' > /tmp/ll_env2.log 2>&1
echo "玲珑环境(修正源)安装已提交"
