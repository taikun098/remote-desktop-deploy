#!/bin/bash
echo "=== lightdm RustDesk2.toml 当前内容 ==="
cat /var/lib/lightdm/.config/rustdesk/RustDesk2.toml 2>/dev/null | sed -E "s/(^key = .*)/key=[REDACTED]/"
echo "=== root RustDesk2.toml 当前内容 ==="
cat /root/.config/rustdesk/RustDesk2.toml 2>/dev/null | sed -E "s/(^key = .*)/key=[REDACTED]/"
echo "=== lightdm 能否读该文件 ==="
ls -la /var/lib/lightdm/.config/rustdesk/RustDesk2.toml
sudo -u lightdm head -2 /var/lib/lightdm/.config/rustdesk/RustDesk2.toml 2>&1 | head -3
echo "=== 服务里 --server 到底读哪个配置（看 /proc/fd）==="
SPID=$(ps -eo pid,args | grep 'rustdesk --server' | grep -v grep | awk '{print $1}' | tail -1)
echo "server pid=$SPID"
ls -l /proc/$SPID/cwd 2>/dev/null
ls -l /proc/$SPID/fd 2>/dev/null | grep -iE 'toml|rustdesk' | head
echo "=== DONE ==="
