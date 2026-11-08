#!/bin/bash
timeout 25 bash -c '
echo 1 | sudo -S rm -rf /home/user/.cache/FreeCAD && echo "已删除 ~/.cache/FreeCAD ✅"
echo "=== 最终全盘复核（无输出=彻底干净）==="
find /opt /usr/local /usr/share /home/user -iname "*freecad*" 2>/dev/null | head
echo "--- 复核结束 ---"
echo "=== DONE ==="
'
