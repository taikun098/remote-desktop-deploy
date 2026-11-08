#!/bin/bash
echo "=== resolvectl ==="
resolvectl query rs.rustdesk.com 2>&1 | head -5
echo "=== node reachability ==="
for spec in "209.250.254.15 21116" "209.250.254.15 21118" "rs-ny.rustdesk.com 21116" "45.9.26.76 21116" "141.11.65.225 21116"; do
  ip=${spec% *}; port=${spec##* }
  if timeout 6 bash -c "cat < /dev/null > /dev/tcp/$ip/$port" 2>/dev/null; then echo "$ip:$port OK"; else echo "$ip:$port FAIL"; fi
done
echo "=== current rustdesk rendezvous in config ==="
for f in /root/.config/rustdesk/RustDesk.toml /var/lib/rustdesk/RustDesk.toml /home/user/.config/rustdesk/RustDesk.toml; do
  echo "--- $f ---"; cat "$f" 2>/dev/null || echo "(absent)"
done
