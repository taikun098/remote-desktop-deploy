#!/bin/bash
echo "=== firewall ==="
ufw status 2>/dev/null || echo "ufw inactive/absent"
echo "=== reachability ==="
for spec in "36.102.84.142 21116" "rs.rustdesk.com 21116" "rs.rustdesk.com 21118" "rs.rustdesk.com 21119" "rs.rustdesk.com 443"; do
  ip=${spec% *}; port=${spec##* }
  if timeout 5 bash -c "cat < /dev/null > /dev/tcp/$ip/$port" 2>/dev/null; then
    echo "$ip:$port OK"
  else
    echo "$ip:$port FAIL"
  fi
done
echo "=== DNS ==="
getent hosts rs.rustdesk.com || echo "DNS FAIL for rs.rustdesk.com"
