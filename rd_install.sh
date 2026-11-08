#!/bin/bash
set -e
DEB=/tmp/rustdesk-1.5.0-x86_64.deb
echo "=== 安装 ==="
sudo -n dpkg -i "$DEB" 2>&1 | grep -viE 'trigger|bamf|desktop-file|hicolor|index|Rebuilding' | tail -8
echo "=== 重载+启用+启动 ==="
sudo -n systemctl daemon-reload
sudo -n systemctl enable rustdesk.service 2>&1 | tail -1
sudo -n systemctl start rustdesk.service
sleep 12
echo "=== 状态 ==="
systemctl is-active rustdesk.service
echo "=== 进程 ==="
ps -eo pid,user,args | grep '[r]ustdesk' | grep -v check-hwcodec
echo "=== 端口 ==="
ss -tlnp 2>/dev/null | grep rustdesk || echo "(无 rustdesk tcp)"
ss -ulnp 2>/dev/null | grep rustdesk || echo "(无 rustdesk udp)"
echo "=== 版本 ==="
/usr/bin/rustdesk --version 2>/dev/null || echo "(n/a)"
echo "=== DONE ==="
