#!/bin/bash
echo "=== rustdesk.service 主单元 ==="
cat /usr/lib/systemd/system/rustdesk.service 2>/dev/null
echo "=== override ==="
cat /etc/systemd/system/rustdesk.service.d/override.conf 2>/dev/null
echo "=== user XAUTHORITY ==="
ls -l /home/user/.Xauthority 2>/dev/null
ls -ld /var/run/user/1000 2>/dev/null
echo "=== DONE ==="
