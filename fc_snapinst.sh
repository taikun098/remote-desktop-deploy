#!/bin/bash
echo 1 | sudo -S systemctl reset-failed fc-snap 2>/dev/null
echo 1 | sudo -S systemd-run --unit=fc-snap --collect \
  bash -c '
    set -x
    snap install freecad
    echo "=== SNAP_DONE ==="
  ' > /tmp/fc_snap.log 2>&1
echo "snap freecad 安装已提交"
