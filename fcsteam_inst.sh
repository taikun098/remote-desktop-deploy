#!/bin/bash
set -x
# 合并为一次后台 apt 会话（避免并发冲突），装 FreeCAD 新版 + Steam
systemctl reset-failed fcsteam-install 2>/dev/null
echo 1 | sudo -S systemd-run --unit=fcsteam-install --collect --setenv=DEBIAN_FRONTEND=noninteractive \
  bash -c '
    set -x
    dpkg --add-architecture i386
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get install -y software-properties-common ca-certificates wget curl
    # FreeCAD 官方稳定版 PPA
    add-apt-repository -y ppa:freecad-maintainers/freecad-ppa
    apt-get update
    apt-get install -y freecad steam-installer libfuse2
    echo "=== INSTALL_DONE ==="
  ' > /tmp/fcsteam_apt.log 2>&1
echo "已提交 FreeCAD+Steam 安装任务，稍后轮询"
