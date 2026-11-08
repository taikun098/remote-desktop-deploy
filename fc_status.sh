#!/bin/bash
timeout 40 bash -c '
echo "=== snap 中 freecad 是否已装 ==="
snap list freecad 2>/dev/null || echo "(未安装)"
echo "=== snap 下载/安装进度 ==="
snap changes 2>/dev/null | grep -iE "freecad|doing|installing" | tail -5 || echo "(无进行中)"
echo "=== snapd 代理状态 ==="
systemctl show snapd -p Environment 2>/dev/null | head -1
echo "=== 新版 snap freecad 翻译文件（中文）==="
SNAP=$(ls -d /snap/freecad/*/ 2>/dev/null | head -1)
if [ -n "$SNAP" ]; then
  echo "snap 目录: $SNAP"
  find "$SNAP" -iname "*zh*" -path "*translations*" 2>/dev/null | head -5
  find "$SNAP" -iname "*.qm" -path "*translations*" 2>/dev/null | grep -iE "zh|cn" | head -5
  echo "--- 含 zh_CN 的翻译 ---"
  find "$SNAP" -iname "*.ts" 2>/dev/null | head -3
  find "$SNAP" -path "*translations*" -iname "freecad*.qm" 2>/dev/null | head -3
fi
echo "=== 旧 AppImage 产物 ==="
ls -la /opt/freecad/FreeCAD.AppImage 2>/dev/null | awk "{print \$5,\$9}" || echo "(无)"
echo "=== 系统里 FreeCAD 可执行 ==="
which freecad freecadcmd 2>/dev/null
echo "=== DONE ==="
'
