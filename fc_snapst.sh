#!/bin/bash
echo "=== fc-snap 单元状态 ==="
systemctl is-active fc-snap
echo "=== journal 进度 ==="
journalctl -u fc-snap --no-pager 2>/dev/null | tail -12
echo "=== snap 本身状态 ==="
snap list freecad 2>/dev/null
snap changes 2>/dev/null | grep -i freecad | tail -3
echo "=== snapd 服务 ==="
systemctl is-active snapd
echo "=== snap 是否在下载/卡住 ==="
ps -eo pid,etime,args | grep -iE '[s]nap.*(install|download)' | head -3
echo "=== DONE ==="
