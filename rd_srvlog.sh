#!/bin/bash
echo "=== --server 日志目录 ==="
ls -la /var/lib/lightdm/.local/share/logs/RustDesk/server/ 2>/dev/null
echo "=== --server 日志全文尾部 50 ==="
sudo -u lightdm tail -50 /var/lib/lightdm/.local/share/logs/RustDesk/server/rustdesk_rCURRENT.log 2>/dev/null
echo "=== 若为空找其他 log ==="
find /var/lib/lightdm/.local/share/logs -name '*.log' 2>/dev/null | head
echo "=== DONE ==="
