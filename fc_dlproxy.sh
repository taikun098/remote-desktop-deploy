#!/bin/bash
# 清掉不完整文件，经局域网代理完整下载 FreeCAD AppImage + 校验 + 解包
echo 1 | sudo -S systemctl stop fc-dl 2>/dev/null; echo 1 | sudo -S systemctl reset-failed fc-dl 2>/dev/null
rm -f /opt/freecad/FreeCAD.AppImage
echo 1 | sudo -S systemd-run --unit=fc-dl --collect \
  bash -c '
    set -x
    cd /opt/freecad
    URL="https://github.com/FreeCAD/FreeCAD/releases/download/1.1.4/FreeCAD_1.1.4-Linux-x86_64-py311.AppImage"
    EXPECT="f6dc6ba676e5ac96a565ebc8d657232f94c6158e85b4352141bd1a46f6b43434"
    curl -fL -x http://192.168.0.6:7897 --retry 3 -o FreeCAD.AppImage "$URL" || echo DOWNLOAD_FAIL
    ls -lh FreeCAD.AppImage
    GOT=$(sha256sum FreeCAD.AppImage | awk "{print \$1}")
    echo "本地sha: $GOT"
    if [ "$GOT" != "$EXPECT" ]; then echo SHA_MISMATCH; else echo SHA_OK; fi
    chmod +x FreeCAD.AppImage
    ./FreeCAD.AppImage --appimage-extract || echo EXTRACT_FAIL
    ls -d squashfs-root && echo EXTRACT_OK
    echo "=== FC_DONE ==="
  ' > /tmp/fc_dl.log 2>&1
echo "FreeCAD 经代理下载已提交"
