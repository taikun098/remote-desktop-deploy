#!/bin/bash
# Steam + libfuse2 安装（detached）
echo 1 | sudo -S systemctl reset-failed steam-install 2>/dev/null
echo 1 | sudo -S systemd-run --unit=steam-install --collect --setenv=DEBIAN_FRONTEND=noninteractive \
  bash -c '
    set -x
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get install -y steam-installer libfuse2
    echo "=== STEAM_DONE ==="
  ' > /tmp/steam.log 2>&1
echo "Steam 安装已提交"
# FreeCAD AppImage 下载+校验+解包（detached，独立于 apt）
echo 1 | sudo -S systemctl reset-failed fc-dl 2>/dev/null
echo 1 | sudo -S systemd-run --unit=fc-dl --collect \
  bash -c '
    set -x
    mkdir -p /opt/freecad && cd /opt/freecad
    URL="https://github.com/FreeCAD/FreeCAD/releases/download/1.1.4/FreeCAD_1.1.4-Linux-x86_64-py311.AppImage"
    SHAURL="https://github.com/FreeCAD/FreeCAD/releases/download/1.1.4/FreeCAD_1.1.4-Linux-x86_64-py311.AppImage-SHA256.txt"
    curl -fL --retry 3 -o FreeCAD.AppImage "$URL" || echo "DOWNLOAD_FAIL"
    curl -fL -o FreeCAD.AppImage.SHA256.txt "$SHAURL" || echo "SHA_FAIL"
    ls -lh FreeCAD.AppImage
    echo "本地sha: $(sha256sum FreeCAD.AppImage | awk "{print \$1}")"
    echo "官方sha: $(grep -o "^[a-f0-9]*" FreeCAD.AppImage.SHA256.txt)"
    chmod +x FreeCAD.AppImage
    ./FreeCAD.AppImage --appimage-extract || echo "EXTRACT_FAIL"
    ls -d squashfs-root 2>/dev/null && echo "解包成功"
    echo "=== FC_DONE ==="
  ' > /tmp/fc_dl.log 2>&1
echo "FreeCAD 下载已提交"
