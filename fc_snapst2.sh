#!/bin/bash
echo "=== snap 进度 ==="
snap changes 2>/dev/null | grep -i freecad | tail -3
echo "=== freecad 是否已装 ==="
snap list freecad 2>/dev/null
echo "=== snapd 下载进程 ==="
ps -eo pid,etime,args | grep -iE '[s]napd' | grep -iE 'download|store|fetch' | head -3
echo "=== 磁盘（snap 占用）==="
du -sh /var/lib/snapd/snaps/*.snap 2>/dev/null | tail -3
df -h / | tail -1
echo "=== 代理下 snap 下载测速 ==="
curl -x http://192.168.0.6:7897 -sI --max-time 10 https://api.snapcraft.io 2>/dev/null | head -1 || echo "snapcraft 经代理不可达"
echo "=== DONE ==="
