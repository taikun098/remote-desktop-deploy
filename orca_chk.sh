#!/bin/bash
echo "=== snap freecad 状态 ==="
snap list freecad 2>/dev/null
snap changes 2>/dev/null | grep -i freecad | tail -2
echo "=== OrcaSlicer 安装位置 ==="
which orcaslicer 2>/dev/null
find / -iname 'OrcaSlicer*' 2>/dev/null | grep -vE 'proc|sys' | head -10
echo "=== OrcaSlicer desktop 入口 ==="
find /usr/share/applications /home/user/.local/share/applications -iname '*orca*' 2>/dev/null
grep -h -A3 'Exec=' $(find /usr/share/applications /home/user/.local/share/applications -iname '*orca*' 2>/dev/null) 2>/dev/null | head
echo "=== libfuse2 是否装了（AppImage 需要）==="
dpkg -l 2>/dev/null | grep -iE 'libfuse2|libfuse2t64' | awk '{print $2,$3}'
echo "=== 尝试运行 OrcaSlicer 看报错 ==="
export DISPLAY=:0
timeout 12 bash -c 'orcaslicer --version 2>&1 | head -5' 2>&1 || echo "orcaslicer 命令启动失败"
echo "=== 进程/崩溃检查 ==="
pgrep -af -i orca | head || echo "(无 orca 进程)"
echo "=== DONE ==="
