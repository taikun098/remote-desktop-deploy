#!/bin/bash
timeout 40 bash -c '
echo "=== findmnt 精确视图 ==="
echo 1 | sudo -S findmnt /var/lib/linglong 2>/dev/null -o TARGET,SOURCE,FSTYPE,OPTIONS
echo "=== /proc/mounts 相关行 ==="
grep -iE "linglong|/data" /proc/mounts 2>/dev/null
echo "=== /data/linglong 内容 ==="
echo 1 | sudo -S ls -la /data/linglong/ 2>/dev/null | head -15 || echo "(无 /data/linglong)"
echo "=== /var/lib/linglong 内容（当前看到的）==="
echo 1 | sudo -S ls -la /var/lib/linglong/ 2>/dev/null | head -15
echo "=== 是否有 backup 残留 ==="
echo 1 | sudo -S ls -la /var/lib/linglong.backup-* 2>/dev/null | head || echo "(无 backup)"
echo "=== fstab 里 linglong 行 ==="
grep -i linglong /etc/fstab 2>/dev/null || echo "(fstab 无 linglong)"
echo "=== mount 单元定义 ==="
echo 1 | sudo -S systemctl cat var-lib-linglong.mount 2>/dev/null | grep -E "What|Where|Type|Options" | head
echo "=== /data 挂载详情 ==="
echo 1 | sudo -S findmnt /data 2>/dev/null -o TARGET,SOURCE,FSTYPE
echo "=== DONE ==="
'
