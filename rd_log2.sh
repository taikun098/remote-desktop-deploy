#!/bin/bash
echo "=== 找 rustdesk 日志 ==="
find /var/lib/lightdm/.config/rustdesk /root/.config/rustdesk -name '*.log' 2>/dev/null | head
echo "=== 日志目录 ==="
ls -la /var/lib/lightdm/.config/rustdesk/ 2>/dev/null
echo "=== 日志尾部（rendezvous/connect/server/key/error）==="
for f in /var/lib/lightdm/.config/rustdesk/log/*.log /var/lib/lightdm/.config/rustdesk/*.log; do
  [ -f "$f" ] || continue
  echo "--- $f ---"
  sudo -n tail -50 "$f" | grep -iE 'rendezvous|server|connect|relay|2111|error|fail|register|key|rendez|online' | tail -25
done
echo "=== DONE ==="
