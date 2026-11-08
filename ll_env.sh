#!/bin/bash
echo 1 | sudo -S systemd-run --unit=ll-env --collect \
  bash -c '
    set -x
    echo "deb [trusted=yes] https://ci.deepin.com/repo/obs/linglong:/CI:/release/xUbuntu_24.04/ ./" | sudo tee /etc/apt/sources.list.d/linglong.list
    sudo apt-get update 2>&1 | tail -5
    echo 1 | sudo -S env DEBIAN_FRONTEND=noninteractive apt-get install -y linglong-bin linglong-installer 2>&1 | tail -15
    echo "=== LLENV_DONE ==="
  ' > /tmp/ll_env.log 2>&1
echo "玲珑环境安装已提交"
