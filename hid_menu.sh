#!/bin/bash
timeout 30 bash -c '
mkdir -p /home/user/.local/share/applications
cp /var/lib/flatpak/exports/share/applications/io.github.jeffshee.Hidamari.desktop /home/user/.local/share/applications/Hidamari.desktop
chown user:user /home/user/.local/share/applications/Hidamari.desktop
chmod +x /home/user/.local/share/applications/Hidamari.desktop
echo "已写入应用菜单目录 ✅"
ls -la /home/user/.local/share/applications/Hidamari.desktop
echo "=== 刷新桌面菜单缓存 ==="
which update-desktop-database >/dev/null 2>&1 && echo 1 | sudo -S update-desktop-database /usr/share/applications >/dev/null 2>&1 && echo "update-desktop-database OK"
echo "=== DONE ==="
'
