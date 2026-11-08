#!/bin/bash
echo "=== user 组（是否在 nopasswdlogin）==="
id user
echo "=== lightdm 自动登录配置 ==="
cat /etc/lightdm/lightdm.conf.d/*.conf 2>/dev/null
echo "=== lightdm 日志（autologin/nopasswdlogin 相关）==="
journalctl -u lightdm --no-pager -n 40 2>/dev/null | grep -iE 'autologin|nopasswdlogin|greeter|session|seat' | tail -20
echo "=== 当前活动 VT ==="
cat /sys/class/tty/tty0/active 2>/dev/null
echo "=== Xorg :1 的 auth 权限 ==="
ls -l /var/run/lightdm/root/:1 /var/run/lightdm/root/:0 2>/dev/null
echo "=== rustdesk --server 当前 DISPLAY（进程环境）==="
P=$(ps -eo pid,args | grep 'rustdesk --server' | grep -v grep | awk '{print $1}' | head -1)
echo "pid=$P"
tr '\0' '\n' < /proc/$P/environ 2>/dev/null | grep -iE '^DISPLAY|^XAUTHORITY'
echo "=== DONE ==="
