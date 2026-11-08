#!/bin/bash
echo "=== 列出 1.1.4 所有 x86_64 AppImage 资产 ==="
curl -s --max-time 25 https://api.github.com/repos/FreeCAD/FreeCAD/releases/latest 2>/dev/null \
  | grep -oP '"browser_download_url":\s*"\K[^"]+' | grep -i 'x86_64.*AppImage' | head
echo "=== 保底 URL 构造 ==="
echo "https://github.com/FreeCAD/FreeCAD/releases/download/1.1.4/FreeCAD_1.1.4-Linux-x86_64.AppImage"
echo "=== DONE ==="
