#!/bin/bash
echo "=== fc-snap 状态 ==="
systemctl is-active fc-snap
echo "=== 日志 ==="
journalctl -u fc-snap --no-pager 2>/dev/null | tail -8
echo "=== snap freecad ==="
snap list freecad 2>/dev/null
snap run freecad.cmd --version 2>/dev/null | head -3 || /snap/bin/freecad --version 2>/dev/null | head -2
echo "=== DONE ==="
