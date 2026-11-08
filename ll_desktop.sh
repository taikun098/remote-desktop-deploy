#!/bin/bash
export DISPLAY=:0
echo "=== 在 :0 桌面启动玲珑商店（保持运行）==="
echo 1 | sudo -S systemctl reset-failed linglong-store-gui 2>/dev/null
echo 1 | sudo -S systemd-run --unit=linglong-store-gui --collect \
  -p User=user -E DISPLAY=:0 -E XAUTHORITY=/home/user/.Xauthority \
  -E HOME=/home/user \
  /usr/bin/linglong-store >/tmp/ll_gui_unit.log 2>&1
sleep 6
echo "=== 进程状态 ==="
pgrep -af 'linglong_store' | grep -v grep | head -3 || echo "(未启动)"
echo "=== unit 状态 ==="
systemctl is-active linglong-store-gui 2>/dev/null
echo "=== 日志（确认连上显示）==="
journalctl -u linglong-store-gui --no-pager 2>/dev/null | tail -6
echo "=== DONE ==="
