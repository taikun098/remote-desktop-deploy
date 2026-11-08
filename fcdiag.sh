#!/bin/bash
echo "=== noble 源里 freecad 是否可装 ==="
apt-cache policy freecad 2>/dev/null | head -8
apt-cache search freecad 2>/dev/null | grep -i 'freecad' | head -5
echo "=== universe 组件是否启用 ==="
grep -rh '^deb ' /etc/apt/sources.list /etc/apt/sources.list.d/*.list 2>/dev/null | head -6
echo "=== snap 是否可用 ==="
which snap && snap --version 2>/dev/null | head -2 || echo "(无 snap)"
echo "=== freecad.org 可达性 ==="
timeout 6 curl -sI -L --max-time 5 https://www.freecad.org 2>/dev/null | head -1 || echo "freecad.org 不可达"
echo "=== GitHub releases 可达性（AppImage 托管处）==="
timeout 6 curl -sI --max-time 5 https://github.com 2>/dev/null | head -1 || echo "github 不可达"
echo "=== i386 已启用？ ==="
dpkg --print-foreign-architectures
echo "=== DONE ==="
