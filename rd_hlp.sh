#!/bin/bash
echo "=== rustdesk 自带 helper/二进制 ==="
ls -la /usr/share/rustdesk/ 2>/dev/null
ls -la /usr/lib/rustdesk/ 2>/dev/null
echo "=== rustdesk bin 下 hwcodec 相关 ==="
find /usr -iname '*hwcodec*' 2>/dev/null | head
echo "=== 当前 rustdesk 进程 ==="
ps -eo pid,args | grep '[r]ustdesk' | grep -v check-hwcodec
echo "=== 双 Xorg 来源 ==="
loginctl list-sessions 2>/dev/null
systemctl status lightdm 2>/dev/null | head -8
echo "=== DISPLAY :0 上有什么进程 ==="
ps -eo pid,user,args | grep -iE 'xfce|xfdesktop|lightdm-greeter|user' | grep -v grep | head
echo "=== DONE ==="
