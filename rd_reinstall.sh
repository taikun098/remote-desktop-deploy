#!/bin/bash
set -e
DEB=/tmp/rustdesk-1.5.0-x86_64.deb
echo "=== 1. 停并禁用服务 ==="
sudo -n systemctl stop rustdesk.service 2>/dev/null; sudo -n systemctl disable rustdesk.service 2>/dev/null; echo ok
echo "=== 2. 卸载包（purge）==="
sudo -n dpkg -P rustdesk 2>&1 | tail -3; echo "purge done"
echo "=== 3. 清理所有 rustdesk 配置/日志 ==="
sudo -n rm -rf /root/.config/rustdesk /var/lib/lightdm/.config/rustdesk /root/.local/share/logs/RustDesk
echo "cleaned"
echo "=== 4. 安装新 deb ==="
sudo -n dpkg -i "$DEB" 2>&1 | tail -5; echo "install done"
echo "=== 5. 重载并启动 ==="
sudo -n systemctl daemon-reload
sudo -n systemctl enable rustdesk.service 2>&1 | tail -1
sudo -n systemctl start rustdesk.service
sleep 12
echo "=== 6. 状态 ==="
systemctl is-active rustdesk.service
echo "=== 7. 进程 ==="
ps -eo pid,user,args | grep '[r]ustdesk' | grep -v check-hwcodec
echo "=== 8. 端口 ==="
ss -tlnp 2>/dev/null | grep rustdesk || echo "(无 rustdesk 监听)"
ss -ulnp 2>/dev/null | grep rustdesk || echo "(无 udp)"
echo "=== DONE ==="
