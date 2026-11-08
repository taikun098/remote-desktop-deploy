#!/bin/bash
echo "=== rustdesk procs now ==="
ps -eo pid,user,cmd | grep -iE '[r]ustdesk' | grep -v grep
echo "=== listening now ==="
ss -tlnp | grep -iE 'rustdesk|2111[0-9]' || echo "no listen"
echo "=== journal tail (errors/connect) ==="
journalctl -u rustdesk --no-pager -n 60 2>/dev/null | grep -iE 'error|warn|fail|connect|rendezvous|server|listen|panic|abort' | tail -25
echo "=== config options section ==="
sed -n '/\[options\]/,+6p' /root/.config/rustdesk/RustDesk.toml 2>/dev/null || echo "no [options]"
