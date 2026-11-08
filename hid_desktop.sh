#!/bin/bash
timeout 40 bash -c '
echo "=== 找 flatpak 的 Hidamari .desktop ==="
F=$(find /var/lib/flatpak/exports/share/applications ~/.local/share/flatpak/exports/share/applications -name "*Hidamari*.desktop" 2>/dev/null | head -1)
echo "来源: $F"
echo "=== 桌面目录 ==="
echo "HOME=$HOME"
ls -d /home/user/Desktop 2>/dev/null || echo "(Desktop 不存在)"
echo "=== 创建桌面快捷方式 ==="
mkdir -p /home/user/Desktop
SRC="${F:-/var/lib/flatpak/exports/share/applications/io.github.jeffshee.Hidamari.desktop}"
cp "$SRC" /home/user/Desktop/Hidamari.desktop 2>/dev/null
chown user:user /home/user/Desktop/Hidamari.desktop
chmod +x /home/user/Desktop/Hidamari.desktop
echo "=== 验证 ==="
ls -la /home/user/Desktop/Hidamari.desktop
echo "--- 内容 ---"
cat /home/user/Desktop/Hidamari.desktop
echo "=== 应用菜单数据目录是否含 flatpak ==="
echo "XDG_DATA_DIRS=$XDG_DATA_DIRS" 2>/dev/null
ls /usr/share/applications/*Hidamari* 2>/dev/null || echo "(系统菜单无 Hidamari 项，需手动刷新)"
echo "=== DONE ==="
'
