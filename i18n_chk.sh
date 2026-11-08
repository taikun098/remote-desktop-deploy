#!/bin/bash
echo "=== 当前 locale ==="
locale 2>/dev/null | head -6
echo "--- 系统默认 locale 文件 ---"
cat /etc/default/locale 2>/dev/null
echo "=== 已安装中文相关包 ==="
dpkg -l 2>/dev/null | grep -iE 'language-pack-zh|fcitx|ibus|fonts-noto-cjk|fonts-wqy' | awk '{print $1,$2,$3}' | head -20
echo "=== Edge 是否已装 ==="
which microsoft-edge 2>/dev/null; dpkg -l 2>/dev/null | grep -i microsoft | head
ls -d /opt/microsoft 2>/dev/null
echo "=== 桌面环境 ==="
echo "XDG_SESSION: $(ls /usr/share/xsessions/ 2>/dev/null)"
echo "=== 中文字体 ==="
fc-list :lang=zh 2>/dev/null | head -5
echo "=== fcitx5 配置痕迹 ==="
ls -la /home/user/.config/fcitx5 2>/dev/null || echo "(无 fcitx5 配置)"
echo "=== DONE ==="
