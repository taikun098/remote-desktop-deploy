#!/bin/bash
echo "=== fc-dl 状态 ==="
systemctl is-active fc-dl
echo "=== fc_dl.log ==="
cat /tmp/fc_dl.log 2>/dev/null | tail -12
echo "=== 校验点 ==="
grep -oE 'DOWNLOAD_FAIL|SHA_MISMATCH|SHA_OK|EXTRACT_OK|EXTRACT_FAIL|FC_DONE' /tmp/fc_dl.log 2>/dev/null
echo "=== DONE ==="
