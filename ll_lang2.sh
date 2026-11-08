#!/bin/bash
timeout 40 bash -c '
echo "=== 商店程序目录里的翻译文件 ==="
ls /opt/linglong-store/translations/ 2>/dev/null | head
find /opt/linglong-store -iname "*zh_CN*" -o -iname "*.qm" 2>/dev/null | head
echo "=== 商店进程的 LANGUAGE/LC_* 环境 ==="
PID=$(pgrep -f linglong_store | head -1)
echo "PID=$PID"
tr "\0" "\n" < /proc/$PID/environ 2>/dev/null | grep -iE "LANGUAGE|LC_|LANG|QT_" | head
echo "=== 商店 settings/选项 配置（找语言项）==="
find /opt/linglong-store -maxdepth 2 -iname "*.conf" -o -iname "*.json" -o -iname "*settings*" 2>/dev/null | head
ls -la /opt/linglong-store 2>/dev/null | head -20
echo "=== DONE ==="
'
