#!/bin/bash
echo "=== FreeCAD 当前版本 ==="
which freecad freecadcmd 2>/dev/null
dpkg -l 2>/dev/null | grep -i freecad | head
freecadcmd --version 2>/dev/null || echo "(无 freecadcmd)"
echo "=== Steam 是否已装 ==="
which steam 2>/dev/null; dpkg -l 2>/dev/null | grep -i steam | head
echo "=== 32位架构(i386)是否启用 ==="
dpkg --print-foreign-architectures 2>/dev/null
echo "=== 磁盘 ==="
df -h / | tail -1
echo "=== 网络可达性（Steam 官方源 / FreeCAD 下载）==="
timeout 5 bash -c 'cat < /dev/null > /dev/tcp/repo.steampowered.com/443' 2>/dev/null && echo "repo.steampowered.com:443 可达" || echo "steam repo 不可达"
echo "=== 显卡/OpenGL（Steam 运行需要）==="
lspci 2>/dev/null | grep -iE 'vga|3d' | head
echo "=== DONE ==="
