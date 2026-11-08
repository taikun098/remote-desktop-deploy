#!/bin/bash
echo "=== rustdesk 启动器内容 ==="
head -60 /usr/share/rustdesk/rustdesk
echo "=== 真实二进制位置 ==="
ls -la /usr/share/rustdesk/ | head -20
find /usr -name 'rustdesk*' -type f -size +1M 2>/dev/null | head
find /usr/share/rustdesk -type f 2>/dev/null | head -20
echo "=== 从真实二进制 grep 配置键名 ==="
RBIN=$(find /usr/share/rustdesk -type f -size +1M 2>/dev/null | head -1)
echo "RBIN=$RBIN"
[ -n "$RBIN" ] && grep -aEo 'rendezvous_server|relay_server|api_server|custom-rendezvous|custom-relay|direct_server' "$RBIN" 2>/dev/null | sort -u | head
echo "=== DONE ==="
