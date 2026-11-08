#!/bin/bash
echo "=== 以 user 在物理桌面 :0 启动 Edge ==="
export DISPLAY=:0
export XAUTHORITY=/home/user/.Xauthority
echo 1 | sudo -S -u user env DISPLAY=:0 XAUTHORITY=/home/user/.Xauthority \
  /usr/bin/microsoft-edge --no-sandbox --new-window "about:blank" >/tmp/edge_gui2.log 2>&1 &
sleep 7
echo "=== Edge GUI 进程 ==="
pgrep -af 'microsoft-edge' | head -5
CNT=$(pgrep -fc 'microsoft-edge --new-window'); echo "新窗口进程数: $CNT"
echo "=== 关闭测试窗口 ==="
pkill -f 'microsoft-edge --new-window' 2>/dev/null
sleep 2
pkill -f 'microsoft-edge' 2>/dev/null
echo "=== 错误日志（若有）==="
grep -iE 'error|missing|failed' /tmp/edge_gui2.log | tail -3 || echo "(无错误)"
echo "=== DONE ==="
