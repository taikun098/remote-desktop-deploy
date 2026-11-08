#!/bin/bash
timeout 30 bash -c '
echo "=== autostart 目录属主 ==="
ls -ld /home/user/.config/autostart 2>/dev/null || echo "(不存在)"
echo "=== 修正属主并写入 ==="
echo 1 | sudo -S mkdir -p /home/user/.config/autostart
echo 1 | sudo -S chown -R user:user /home/user/.config/autostart
cat > /home/user/.config/autostart/hidamari.desktop <<EOF
[Desktop Entry]
Type=Application
Name=Hidamari
Comment=Dynamic wallpaper
Exec=flatpak run io.github.jeffshee.Hidamari
X-GNOME-Autostart-enabled=true
EOF
chmod +x /home/user/.config/autostart/hidamari.desktop
echo "=== 验证 ==="
ls -la /home/user/.config/autostart/hidamari.desktop
cat /home/user/.config/autostart/hidamari.desktop
echo "=== DONE ==="
'
