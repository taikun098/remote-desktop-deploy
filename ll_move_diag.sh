#!/bin/bash
timeout 40 bash -c '
echo "=== 是否已是挂载点 ==="
mount | grep -i linglong || echo "(非挂载点)"
echo "=== 谁占用 /var/lib/linglong ==="
echo 1 | sudo -S fuser -mv /var/lib/linglong 2>&1 | head -20
echo "=== linglong 相关 systemd 服务 ==="
systemctl list-units --all 2>/dev/null | grep -iE "linglong|ll-" | head
echo "=== linglong 相关进程 ==="
pgrep -af -i "ll-service|linglong|ll-service" | grep -vE "grep|bash /tmp" | head
echo "=== /data 挂载与可用空间 ==="
df -h /data 2>/dev/null | tail -1 || echo "(无 /data)"
echo "=== /var/lib/linglong 大小 ==="
echo 1 | sudo -S du -sh /var/lib/linglong 2>/dev/null
echo "=== DONE ==="
'
