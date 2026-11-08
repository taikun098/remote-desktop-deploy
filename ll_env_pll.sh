#!/bin/bash
echo "=== ll-env 状态 ==="
systemctl is-active ll-env 2>/dev/null || echo "inactive(已完成)"
echo "=== journal ==="
journalctl -u ll-env --no-pager 2>/dev/null | tail -12
echo "=== 校验点 ==="
grep -oE 'LLENV_DONE|^E:.*|无法|错误' /tmp/ll_env.log 2>/dev/null | tail
echo "=== ll-cli ==="
which ll-cli 2>/dev/null && ll-cli --version 2>/dev/null | head -1
echo "=== 已装玲珑包 ==="
dpkg -l 2>/dev/null | grep -iE 'linglong-(bin|installer)' | awk '{print $2,$3}'
echo "=== DONE ==="
