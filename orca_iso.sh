#!/bin/bash
export DISPLAY=:0
echo "=== 测1: zenity(GTK) 连 :0 ==="
echo 1 | sudo -S -u user env DISPLAY=:0 XAUTHORITY=/home/user/.Xauthority timeout 5 zenity --info --text=test 2>&1 | head -3; echo "zenity exit=$?"
echo "=== 测2: OrcaSlicer --appimage-extract-and-run ==="
echo 1 | sudo -S -u user env DISPLAY=:0 XAUTHORITY=/home/user/.Xauthority \
  timeout 12 /opt/orcaslicer/OrcaSlicer.AppImage --appimage-extract-and-run 2>/tmp/orca_e.log
echo "exit=$?"
pgrep -af -i orca | head -2 || echo "(无 orca 进程)"
tail -12 /tmp/orca_e.log 2>/dev/null
echo "=== 测3: 检查 ~/.config/OrcaSlicer 配置是否损坏 ==="
ls -la /home/user/.config/OrcaSlicer 2>/dev/null | head
echo "=== DONE ==="
