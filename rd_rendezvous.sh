#!/bin/bash
set -e
cfg=/root/.config/rustdesk/RustDesk.toml
echo "=== backup config ==="
cp "$cfg" "${cfg}.bak-ipdirect"
echo "=== set rendezvous to rs-ny (reachable node) ==="
if grep -q 'custom-rendezvous-server' "$cfg"; then
  echo "(already set, skip append)"
else
  printf '\n[options]\ncustom-rendezvous-server = "rs-ny.rustdesk.com"\n' >> "$cfg"
  echo "(appended options)"
fi
echo "=== resulting [options] ==="
sed -n '/\[options\]/,$p' "$cfg"
echo "=== restart rustdesk ==="
systemctl restart rustdesk
sleep 8
echo "=== service ==="
systemctl is-active rustdesk
echo "=== listening ==="
ss -tlnp | grep -iE 'rustdesk|2111[0-9]' || echo "still no listen"
echo "=== conns ==="
ss -tnp | grep -iE 'rustdesk|2111[0-9]' || echo "no established"
echo "=== procs ==="
ps -eo pid,user,cmd | grep -iE '[r]ustdesk' | grep -v grep
