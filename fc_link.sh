#!/bin/bash
echo 1 | sudo -S true 2>/dev/null
SQUASH=/opt/freecad/squashfs-root
echo "=== 核心 FreeCAD 中文翻译文件 ==="
find $SQUASH -iname 'FreeCAD*.qm' 2>/dev/null | grep -iE 'zh|CN|TW' | head
echo "--- 主 translations 目录内容(采样) ---"
ls $SQUASH/usr/share/freecad/translations/ 2>/dev/null | grep -iE 'zh|CN' | head || echo "(该目录无中文)"
echo "=== 用 sudo 建 freecadcmd 软链 ==="
echo 1 | sudo -S ln -sf $SQUASH/usr/bin/freecadcmd /usr/local/bin/freecadcmd
ls -la /usr/local/bin/freecadcmd 2>/dev/null
which freecadcmd
echo "=== 创建桌面菜单项 ==="
cat > /tmp/freecad.desktop <<'EOF'
[Desktop Entry]
Type=Application
Name=FreeCAD
Name[zh_CN]=FreeCAD
Comment=3D CAD modeler
Comment[zh_CN]=三维CAD建模
Exec=/usr/local/bin/freecad
Icon=freecad
Terminal=false
Categories=Graphics;3DGraphics;Engineering;
StartupNotify=true
EOF
echo 1 | sudo -S install -o root -g root -m 644 /tmp/freecad.desktop /usr/share/applications/freecad.desktop
ls -la /usr/share/applications/freecad.desktop 2>/dev/null
echo "=== DONE ==="
