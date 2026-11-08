#!/bin/bash
echo "=== 1.1.4 全部 AppImage 资产 ==="
curl -x http://192.168.0.6:7897 -s --max-time 30 https://api.github.com/repos/FreeCAD/FreeCAD/releases/latest 2>/dev/null \
  | grep -oP '"browser_download_url":\s*"\K[^"]+' | grep -i 'AppImage' | grep -viE 'sha256|zsync'
echo "=== 对比：本机已下载的 py311 是否就是标准唯一版 ==="
echo "已下: FreeCAD_1.1.4-Linux-x86_64-py311.AppImage"
echo "=== DONE ==="
