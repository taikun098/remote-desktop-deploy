#!/bin/bash
echo "=== ll-store 状态 ==="
systemctl is-active ll-store
echo "=== journal 进度 ==="
journalctl -u ll-store --no-pager 2>/dev/null | tail -15
echo "=== 校验点 ==="
grep -oE 'DOWNLOAD_FAIL|SHA_MISMATCH|SHA_OK|INSTALL_FAIL|LL_DONE' /tmp/ll_store.log 2>/dev/null
echo "=== 已装包 ==="
dpkg -l 2>/dev/null | grep -iE 'linglong|ll-cli' | awk '{print $2,$3}' | head
which ll-cli 2>/dev/null
which linglong-store 2>/dev/null
echo "=== 桌面入口 ==="
find /usr/share/applications -iname '*linglong*' -o -iname '*玲珑*' 2>/dev/null | head
echo "=== DONE ==="
