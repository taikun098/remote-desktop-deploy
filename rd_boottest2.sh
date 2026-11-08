#!/bin/bash
echo "=== 开机时间 ==="
uptime -s
echo "=== 桌面自动登录 ==="
echo "活动终端: $(cat /sys/class/tty/tty0/active)"
ps -eo pid,user,args | grep '[X]org :0' | head -1
who 2>/dev/null
echo "=== 自启服务总览 ==="
for s in rustdesk novnc vnc easytier; do
  printf "%-10s : %s / %s\n" "$s" "$(systemctl is-active $s)" "$(systemctl is-enabled $s 2>&1)"
done
echo "=== 端口监听 ==="
ss -tlnp 2>/dev/null | grep -E '5900|6080|21118' 
echo "=== rustdesk 21118 握手 ==="
timeout 3 bash -c 'exec 3<>/dev/tcp/127.0.0.1/21118; head -c 12 <&3 | xxd' 2>&1 || echo "(无响应)"
echo "=== 5900 VNC 握手 ==="
timeout 3 bash -c 'exec 3<>/dev/tcp/127.0.0.1/5900; head -c 12 <&3 | xxd' 2>&1 || echo "(无响应)"
echo "=== EasyTier tun0 ==="
ip addr show tun0 2>/dev/null | grep 'inet 10.1.0.20' || echo "tun0 未就绪"
echo "=== rustdesk 日志尾 4 ==="
tail -4 /home/user/.local/share/logs/RustDesk/server/rustdesk_rCURRENT.log 2>/dev/null
echo "=== DONE ==="
