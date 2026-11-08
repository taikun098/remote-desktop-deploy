#!/bin/bash
echo "=== journal -u fc-dl ==="
journalctl -u fc-dl --no-pager 2>/dev/null | tail -20
echo "=== 实际文件 ==="
ls -lh /opt/freecad/FreeCAD.AppImage 2>/dev/null
ls -d /opt/freecad/squashfs-root 2>/dev/null && echo "已解包" || echo "未解包"
echo "=== sha 校验 ==="
GOT=$(sha256sum /opt/freecad/FreeCAD.AppImage 2>/dev/null | awk '{print $1}')
echo "本地: $GOT"
echo "官方: f6dc6ba676e5ac96a565ebc8d657232f94c6158e85b4352141bd1a46f6b43434"
echo "=== DONE ==="
