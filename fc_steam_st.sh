#!/bin/bash
echo "=== Steam 是否真装上 ==="
which steam 2>/dev/null
dpkg -l 2>/dev/null | grep -i steam | awk '{print $2,$3}' | head
ls -ld /usr/games/steam 2>/dev/null
echo "--- steam 安装日志(journal) ---"
journalctl -u steam-install --no-pager 2>/dev/null | grep -iE 'setting up|install|error|fail|steam' | tail -8
echo "=== FreeCAD 下载进度 ==="
ls -lh /opt/freecad/FreeCAD.AppImage 2>/dev/null
echo "--- fc 日志 ---"
journalctl -u fc-dl --no-pager 2>/dev/null | tail -6
echo "=== DONE ==="
