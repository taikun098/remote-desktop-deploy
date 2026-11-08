#!/bin/bash
echo "=== 给 snapd 配置代理加速 ==="
echo 1 | sudo -S snap set system proxy.http=http://192.168.0.6:7897
echo 1 | sudo -S snap set system proxy.https=http://192.168.0.6:7897
echo 1 | sudo -S systemctl restart snapd 2>/dev/null
sleep 5
echo "=== snap 代理配置 ==="
snap get system proxy.http proxy.https 2>/dev/null
echo "=== 重启 snapd 后 snap 继续安装 ==="
systemctl is-active snapd
echo "=== snap 进度 ==="
snap changes 2>/dev/null | grep -i freecad | tail -2
echo "=== DONE ==="
