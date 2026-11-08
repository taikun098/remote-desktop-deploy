#!/bin/bash
for i in $(seq 1 90); do
  if ! systemctl is-active fcsteam-install >/dev/null 2>&1; then break; fi
  sleep 10
done
echo "=== apt 日志尾部 ==="
tail -25 /tmp/fcsteam_apt.log 2>/dev/null
echo "=== 是否 DONE ==="
grep -c INSTALL_DONE /tmp/fcsteam_apt.log 2>/dev/null
echo "=== 验证 FreeCAD ==="
which freecad freecadcmd 2>/dev/null
dpkg -l 2>/dev/null | grep -i freecad | awk '{print $2,$3}' | head
echo "=== 验证 Steam ==="
which steam 2>/dev/null; dpkg -l 2>/dev/null | grep -i steam | awk '{print $2,$3}' | head
echo "=== DONE ==="
