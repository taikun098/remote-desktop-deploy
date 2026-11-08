#!/bin/bash
set -x
# 1. IM 环境变量写入 /etc/environment（若未含则追加）
add_env() {
  grep -q "$1" /etc/environment 2>/dev/null || echo "$1" >> /etc/environment
}
add_env "GTK_IM_MODULE=fcitx"
add_env "QT_IM_MODULE=fcitx"
add_env "XMODIFIERS=@im=fcitx"
add_env "SDL_IM_MODULE=fcitx"
echo "=== /etc/environment ==="
cat /etc/environment

# 2. im-config 设 fcitx 为默认
im-config -n fcitx5 2>&1 | tail -3 || im-config -n fcitx 2>&1 | tail -3
echo "=== xinputrc ==="
cat /etc/X11/xinit/xinputrc 2>/dev/null

# 3. fcitx5 开机自启（用户 + 全局）
mkdir -p /home/user/.config/autostart
cat > /home/user/.config/autostart/fcitx5.desktop <<'EOF'
[Desktop Entry]
Type=Application
Name=fcitx5
Comment=Input Method
Exec=/usr/bin/fcitx5
X-GNOME-Autostart-enabled=true
NoDisplay=false
EOF
chown user:user /home/user/.config/autostart/fcitx5.desktop
# 全局也放一份（xfce autostart 读取）
mkdir -p /etc/xdg/autostart
cat > /etc/xdg/autostart/fcitx5.desktop <<'EOF'
[Desktop Entry]
Type=Application
Name=fcitx5
Comment=Input Method
Exec=/usr/bin/fcitx5
X-GNOME-Autostart-enabled=true
NoDisplay=false
EOF
echo "=== 自启入口 ==="
ls -l /home/user/.config/autostart/fcitx5.desktop /etc/xdg/autostart/fcitx5.desktop
echo "=== fcitx5 命令存在？ ==="
which fcitx5
echo "=== DONE ==="
