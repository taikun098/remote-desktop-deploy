#!/bin/bash
timeout 40 bash -c '
echo "=== 是否已持久化（fstab）==="
grep -i linglong /etc/fstab 2>/dev/null || echo "(fstab 无 linglong，需添加)"
echo "=== 写入 fstab 持久化 bind 挂载 ==="
if ! grep -q "/data/linglong /var/lib/linglong" /etc/fstab 2>/dev/null; then
  echo "/data/linglong /var/lib/linglong none bind 0 0" | echo 1 | sudo -S tee -a /etc/fstab >/dev/null
  echo "已添加"
else
  echo "已存在"
fi
echo 1 | sudo -S systemctl daemon-reload 2>/dev/null
echo "=== 验证 fstab 挂载单元可解析 ==="
echo 1 | sudo -S systemctl cat var-lib-linglong.mount 2>/dev/null | grep -E "What|Where|Options" | head
echo "=== 当前挂载状态 ==="
echo 1 | sudo -S findmnt /var/lib/linglong 2>/dev/null -o TARGET,SOURCE
echo "=== 玲珑数据实际所在（确认在 /data/linglong）==="
echo 1 | sudo -S du -sh /data/linglong 2>/dev/null
echo "=== ll-cli 仍能识别应用（移动后数据未坏）==="
ll-cli list 2>/dev/null | head -8
echo "=== DONE ==="
'
