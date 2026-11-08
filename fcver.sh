#!/bin/bash
echo "=== 查询 FreeCAD 最新稳定版 ==="
# 用 GitHub API 拿最新 release 的 AppImage 资产 URL
VER=$(curl -s --max-time 20 https://api.github.com/repos/FreeCAD/FreeCAD/releases/latest 2>/dev/null | grep -oP '"tag_name":\s*"\K[^"]+' | head -1)
echo "最新 tag: ${VER:-未知}"
URL=$(curl -s --max-time 20 https://api.github.com/repos/FreeCAD/FreeCAD/releases/latest 2>/dev/null | grep -oP '"browser_download_url":\s*"\K[^"]+Linux[^"]+\.AppImage' | head -1)
echo "AppImage URL: ${URL:-未找到}"
# 保底：若 API 失败，尝试已知稳定版模式
if [ -z "$URL" ]; then
  echo "尝试用 releases/latest 重定向获取版本"
  LOC=$(curl -sI --max-time 20 https://github.com/FreeCAD/FreeCAD/releases/latest 2>/dev/null | grep -i '^location:' | tr -d '\r' | awk '{print $2}')
  echo "latest 指向: $LOC"
fi
echo "=== DONE ==="
