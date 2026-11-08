#!/bin/bash
timeout 30 bash -c '
echo "=== 配 XFCE 开机自启 ==="
mkdir -p /home/user/.config/autostart
cat > /home/user/.config/autostart/hidamari.desktop <<EOF
[Desktop Entry]
Type=Application
Name=Hidamari
Comment=Dynamic wallpaper
Exec=flatpak run io.github.jeffshee.Hidamari
X-GNOME-Autostart-enabled=true
EOF
chown user:user /home/user/.config/autostart/hidamari.desktop
echo "已写入自启条目 ✅"
ls -la /home/user/.config/autostart/hidamari.desktop
echo "=== 确认壁纸目录 ==="
ls -lh /home/user/Videos/Hidamari/ | tail -3
echo "=== DONE ==="
'
