#!/bin/bash
echo "=== 1. 开机时间（确认是否真重启）==="
uptime -p
uptime -s
echo "=== 2. 桌面自动登录 ==="
echo "活动终端: $(cat /sys/class/tty/tty0/active)"
echo "--- X 会话 ---"
ps -eo pid,user,args | grep '[X]org :0' | head -2
who 2>/dev/null
echo "--- lightdm 会话 ---"
loginctl list-sessions 2>/dev/null
echo "=== 3. rustdesk 服务 ==="
systemctl is-active rustdesk; systemctl is-enabled rustdesk 2>&1
echo "--- 运行用户 ---"
ps -eo pid,user,args | grep '[r]ustdesk --server' | head -2
echo "=== 4. 21118 直连监听 ==="
ss -tlnp 2>/dev/null | grep 21118 || echo "21118 未监听"
echo "--- 21118 握手测试 ---"
timeout 3 bash -c 'exec 3<>/dev/tcp/127.0.0.1/21118; head -c 12 <&3 | xxd' 2>&1 || echo "(无响应)"
echo "=== 5. noVNC / x11vnc 自启 ==="
systemctl is-active novnc vnc
ss -tlnp 2>/dev/null | grep -E '5900|6080'
echo "=== 6. rustdesk 到 yc 注册/心跳（日志）==="
tail -8 /home/user/.local/share/logs/RustDesk/server/rustdesk_rCURRENT.log 2>/dev/null
echo "=== 7. EasyTier 自启 ==="
systemctl is-active easytier
ip addr show tun0 2>/dev/null | grep 'inet 10.1.0.20' || echo "tun0 10.1.0.20 未就绪"
echo "=== DONE ==="
