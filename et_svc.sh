#!/bin/bash
set -e
sudo -n cp /tmp/easytier.service /etc/systemd/system/easytier.service
sudo -n systemctl daemon-reload
sudo -n systemctl enable easytier.service
sudo -n systemctl start easytier.service
sleep 4
echo "--- status ---"
sudo -n systemctl is-active easytier.service
echo "--- tun ipv4 ---"
ip -4 addr show tun0 2>/dev/null | grep -E 'inet 10\.' || echo "(no tun0 yet)"
echo "--- unit file ---"
cat /etc/systemd/system/easytier.service
echo "--- process ---"
ps -eo pid,args | grep '[e]asytier-core' || echo "(no process)"
echo "--- DONE ---"
