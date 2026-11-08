#!/bin/bash
B=/usr/share/rustdesk/lib/librustdesk.so
echo "=== custom-* 选项键名 ==="
grep -aEo 'custom-[a-z-]+' "$B" 2>/dev/null | sort -u | head -20
echo "=== options 段 / 相关键 ==="
grep -aEo '\[options\]|custom-rendezvous-server|custom-relay-server|custom-api-server|rendezvous_server|relay_server|api_server|api_key|"key"' "$B" 2>/dev/null | sort -u | head -30
echo "=== key 相关完整键 ==="
grep -aEo '[a-z_]*(key|Key)[a-z_]*' "$B" 2>/dev/null | grep -iE 'key' | sort -u | head -30
echo "=== DONE ==="
