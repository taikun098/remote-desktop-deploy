#!/bin/bash
echo "=== vnc.service 完整状态 ==="
systemctl status vnc.service --no-pager 2>&1 | head -20
echo "=== 本次开机 journalctl -u vnc ==="
journalctl -u vnc --since "2026-11-02 11:29:00" --no-pager 2>/dev/null | tail -30
echo "=== 是否有 ordering cycle ==="
journalctl --since "2026-11-02 11:29:00" --no-pager 2>/dev/null | grep -iE 'cycle|skipped|vnc' | head -10
echo "=== lightdm 是否起 ==="
systemctl is-active lightdm; ps -eo pid,user,args | grep '[l]ightdm' | head -2
echo "=== DONE ==="
