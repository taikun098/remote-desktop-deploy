#!/bin/bash
echo "=== rustdesk 进程 ==="
ps -eo pid,user,args | grep '[r]ustdesk' | grep -v check-hwcodec
MPID=$(ps -eo pid,args | grep 'rustdesk --service' | grep -v grep | awk '{print $1}' | head -1)
echo "=== 主 --service 进程 ($MPID) 打开的配置文件 ==="
ls -l /proc/$MPID/fd 2>/dev/null | grep -iE 'rustdesk|toml|config|\.cfg' | head -20
echo "=== 其 cwd / 相关 ==="
readlink /proc/$MPID/cwd 2>/dev/null
echo "=== 是否有 RustDesk2.toml / 其他配置文件被打开 ==="
ls -l /proc/$MPID/fd 2>/dev/null | grep -oE '/[^ ]+\.(toml|cfg|conf)' | sort -u | head
echo "=== DONE ==="
