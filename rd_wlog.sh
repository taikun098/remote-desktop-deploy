#!/bin/bash
echo "=== user rustdesk 日志路径 ==="
ls -la /home/user/.local/share/logs/RustDesk/server/ 2>/dev/null | head
echo "=== user --server 日志尾部 25 行 ==="
tail -25 /home/user/.local/share/logs/RustDesk/server/rustdesk_rCURRENT.log 2>/dev/null
echo "=== 21116 ==="
ss -tlnp 2>/dev/null | grep 21116 || echo "TCP未监听"
ss -ulnp 2>/dev/null | grep 21116 || echo "UDP未监听"
echo "=== 全部 rustdesk 监听 ==="
ss -tlnp 2>/dev/null | grep rustdesk
ss -ulnp 2>/dev/null | grep rustdesk
echo "=== DONE ==="
