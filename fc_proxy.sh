#!/bin/bash
echo "=== 测试局域网代理 192.168.0.6:7897 ==="
timeout 8 bash -c 'cat < /dev/null > /dev/tcp/192.168.0.6/7897' 2>/dev/null && echo "代理端口可达" || echo "代理端口不可达"
echo "--- 代理下载速度测试（15秒）---"
timeout 18 curl -x http://192.168.0.6:7897 -sL --max-time 15 -o /dev/null -w "速度: %{speed_download} B/s, 已下: %{size_download} B\n" \
  "https://github.com/FreeCAD/FreeCAD/releases/download/1.1.4/FreeCAD_1.1.4-Linux-x86_64-py311.AppImage" 2>/dev/null
echo "=== DONE ==="
