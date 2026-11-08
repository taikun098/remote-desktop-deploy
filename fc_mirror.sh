#!/bin/bash
echo "=== 停掉卡住的下载 ==="
echo 1 | sudo -S systemctl stop fc-dl 2>/dev/null
pkill -f 'curl.*FreeCAD.AppImage' 2>/dev/null
sleep 1
echo "=== 测试 GitHub 加速镜像下载速度（限时 25 秒看速度）==="
cd /opt/freecad
for M in "https://ghfast.top/" "https://gh-proxy.com/" "https://ghproxy.net/" "https://mirror.ghproxy.com/"; do
  echo "--- 测试 $M ---"
  timeout 20 curl -sL --max-time 18 -o /dev/null -w "速度: %{speed_download} B/s, 已下: %{size_download} B\n" \
    "${M}https://github.com/FreeCAD/FreeCAD/releases/download/1.1.4/FreeCAD_1.1.4-Linux-x86_64-py311.AppImage" 2>/dev/null
done
echo "=== 若全部很慢，将退而用 snap ==="
echo "=== DONE ==="
