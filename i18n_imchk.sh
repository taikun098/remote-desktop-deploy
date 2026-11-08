#!/bin/bash
echo "=== 当前 fcitx5 profile ==="
cat /home/user/.config/fcitx5/profile 2>/dev/null
echo "=== fcitx5 自启入口 ==="
ls /etc/xdg/autostart/fcitx5* /home/user/.config/autostart/fcitx5* 2>/dev/null || echo "(无自启入口)"
echo "=== im-config 当前 ==="
cat /etc/X11/xinit/xinputrc 2>/dev/null || echo "(无 xinputrc)"
which im-config 2>/dev/null || echo "(无 im-config)"
echo "=== 当前 IM 环境变量 ==="
grep -iE 'IM_MODULE|XMODIFIERS|INPUT_METHOD|XIM' /etc/environment 2>/dev/null || echo "(环境变量未设)"
echo "=== DONE ==="
