#!/bin/bash
timeout 30 bash -c '
echo "=== /etc/fstab 全文（带行号）==="
cat -n /etc/fstab
echo "=== 逐行校验字段数（正确应为>=3列）==="
awk "{n=gsub(/[^ ]+/,\" \"); printf \"行%d: %d 字段  %s\n\", NR, n, \$0}" /etc/fstab
echo "=== DONE ==="
'
