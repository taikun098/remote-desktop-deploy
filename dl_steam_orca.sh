#!/bin/bash
echo "########## OrcaSlicer 诊断 ##########"
echo "=== 安装位置 ==="
which orcaslicer 2>/dev/null
find / -iname 'OrcaSlicer*' -not -path '*/proc/*' -not -path '*/sys/*' 2>/dev/null | head -8
echo "=== desktop 入口 ==="
D=$(find /usr/share/applications /home/user/.local/share/applications -iname '*orca*' 2>/dev/null | head -1)
echo "desktop: $D"
grep -E 'Exec|Name|Path' "$D" 2>/dev/null
echo "=== libfuse 检查 ==="
dpkg -l 2>/dev/null | grep -iE 'libfuse2' | awk '{print $2,$3}'
ls /dev/fuse 2>/dev/null && echo "fuse设备存在" || echo "无 /dev/fuse"
echo "=== 试启动（:0, user）==="
export DISPLAY=:0
echo 1 | sudo -S -u user env DISPLAY=:0 XAUTHORITY=/home/user/.Xauthority \
  timeout 15 orcaslicer 2>/tmp/orca_run.log; echo "exit=$?"
pgrep -af -i orca | head -2 || echo "(无 orca 进程)"
echo "--- 启动日志 ---"
tail -15 /tmp/orca_run.log 2>/dev/null
echo
echo "########## Steam 代理 ##########"
echo "=== steam 客户端状态 ==="
pgrep -af -i steam | head -3 || echo "(无 steam 进程)"
echo "=== 现有代理环境 ==="
grep -riE 'proxy' /etc/environment /etc/profile.d/*.sh /home/user/.profile /home/user/.bashrc 2>/dev/null | grep -iv '^#' | head
echo "=== steam desktop 入口 ==="
grep -E 'Exec' /usr/share/applications/steam.desktop 2>/dev/null | head -2
echo "=== DONE ==="
