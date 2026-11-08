#!/bin/bash
timeout 40 bash -c '
echo "=== snap 内核心翻译文件（freecad 主界面 *.qm）==="
find /snap/freecad/2741 -iname "freecad_*.qm" 2>/dev/null | head -10
echo "--- 含 zh 的 qm ---"
find /snap/freecad/2741 -iname "*.qm" 2>/dev/null | grep -iE "/zh|_zh" | head -10
echo "--- translations 目录里的 qm 计数 ---"
find /snap/freecad/2741 -path "*translations*" -iname "*.qm" 2>/dev/null | wc -l
echo "=== /usr/local/bin/freecad 指向 ==="
ls -la /usr/local/bin/freecad /usr/local/bin/freecadcmd 2>/dev/null
echo "=== snap freecad 能否启动（版本）==="
timeout 20 snap run freecadcmd --version 2>&1 | tail -3 || echo "(启动异常)"
echo "=== 旧 AppImage 启动器 /opt/freecad ==="
ls -la /opt/freecad/ 2>/dev/null | head
echo "=== DONE ==="
'
