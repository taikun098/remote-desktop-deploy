#!/bin/bash
timeout 120 bash -c '
echo "=== 1) 卸载 snap freecad ==="
echo 1 | sudo -S snap remove freecad 2>&1 | tail -3
sleep 2
snap list freecad 2>/dev/null && echo "(仍在)" || echo "snap freecad 已移除 ✅"
echo "=== 2) 删除旧 AppImage /opt/freecad ==="
echo 1 | sudo -S rm -rf /opt/freecad && echo "已删除 /opt/freecad ✅"
echo "=== 3) 删除启动器软链 ==="
echo 1 | sudo -S rm -f /usr/local/bin/freecad /usr/local/bin/freecadcmd && echo "已删除 freecad/freecadcmd ✅"
echo "=== 4) 删除桌面图标 ==="
echo 1 | sudo -S rm -f /home/user/Desktop/freecad_freecad.desktop && echo "已删除桌面图标 ✅"
echo "=== 5) 删除用户配置 ==="
echo 1 | sudo -S rm -rf /home/user/.config/FreeCAD && echo "已删除 ~/.config/FreeCAD ✅"
echo "=== 6) 查找其他 freecad 残留 ==="
find /usr/local /usr/share/applications /home/user/.local/share/applications /home/user/Desktop -iname "*freecad*" 2>/dev/null | head
echo "=== 残留检查 ==="
ls /opt/freecad 2>/dev/null || echo "/opt/freecad 不存在 ✅"
which freecad freecadcmd 2>/dev/null || echo "freecad/freecadcmd 不在 PATH ✅"
ls /home/user/Desktop/*.desktop 2>/dev/null | grep -i freecad || echo "桌面无 freecad 图标 ✅"
echo "=== 释放空间检查 ==="
df -h / | tail -1
echo "=== DONE ==="
'
