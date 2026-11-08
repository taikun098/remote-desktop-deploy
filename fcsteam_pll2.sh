#!/bin/bash
echo "=== 单元状态 ==="
systemctl is-active fcsteam-install
echo "=== journal 尾部 ==="
journalctl -u fcsteam-install --no-pager 2>/dev/null | tail -20
echo "=== 已装关键包 ==="
dpkg -l 2>/dev/null | grep -iE 'freecad|steam' | awk '{print $2,$3}' | head
echo "=== DONE ==="
