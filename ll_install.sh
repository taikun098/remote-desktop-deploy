#!/bin/bash
echo 1 | sudo -S systemctl reset-failed ll-store 2>/dev/null
echo 1 | sudo -S systemd-run --unit=ll-store --collect \
  bash -c '
    set -x
    cd /tmp
    URL="https://github.com/HanHan666666/flutter-linglong-store/releases/download/v3.7.0/linglong-store_3.7.0_amd64.deb"
    EXPECT="E8DECF181BB82A7F9E15A1B6579498798DE79239B2A435453ABF7FE97E8BF8A9"
    curl -fL -x http://192.168.0.6:7897 --retry 3 -o llstore.deb "$URL" || echo DOWNLOAD_FAIL
    ls -lh llstore.deb
    GOT=$(sha256sum llstore.deb | awk "{print \$1}")
    echo "本地sha: $GOT"
    if [ "$GOT" != "$EXPECT" ]; then echo SHA_MISMATCH; exit 1; fi
    echo SHA_OK
    export DEBIAN_FRONTEND=noninteractive
    apt-get install -y ./llstore.deb || dpkg -i ./llstore.deb 2>/dev/null || echo INSTALL_FAIL
    echo "=== LL_DONE ==="
  ' > /tmp/ll_store.log 2>&1
echo "玲珑商店下载安装已提交"
