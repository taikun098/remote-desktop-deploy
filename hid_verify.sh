#!/bin/bash
timeout 30 bash -c '
sleep 2
sudo -u user env DISPLAY=:0 import -window root /tmp/wp2.png 2>/dev/null && echo "OK"
ls -lh /tmp/wp2.png 2>/dev/null | awk "{print \$5}"
echo "=== DONE ==="
'
