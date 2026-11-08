#!/bin/bash
set -e
sudo -n cp /tmp/easytier.service /etc/systemd/system/easytier.service
sudo -n systemctl daemon-reload
sudo -n systemctl restart easytier.service
sleep 8
echo "--- status ---"
sudo -n systemctl is-active easytier.service
echo "--- unit ExecStart ---"
grep ExecStart /etc/systemd/system/easytier.service
echo "--- peer 状态 ---"
timeout 8 /usr/local/bin/easytier-cli peer 2>&1 | head -20
echo "--- tun ipv4 ---"
ip -4 addr show tun0 2>/dev/null | grep -E 'inet 10\.' || echo "(no tun0)"
echo "--- DONE ---"
