#!/bin/bash
echo "=== 1. x11vnc 是否还活着 + 5900 监听 ==="
ps -eo pid,args | grep '[x]11vnc'
ss -tlnp 2>/dev/null | grep 5900
echo "=== 2. 本地直连 5900 拿 VNC 握手（RFB banner）==="
timeout 3 bash -c 'exec 3<>/dev/tcp/127.0.0.1/5900; head -c 12 <&3 | xxd' 2>&1 || echo "(5900 连接失败)"
echo "=== 3. novnc.service 状态 + websockify 最近日志 ==="
systemctl is-active novnc.service
journalctl -u novnc --no-pager -n 25 2>/dev/null | tail -25
echo "=== 4. websockify 进程 + 6080 监听 ==="
ps -eo pid,args | grep '[w]ebsockify'
ss -tlnp 2>/dev/null | grep 6080
echo "=== 5. 物理桌面 / 显示情况 ==="
echo "活动终端: $(cat /sys/class/tty/tty0/active)"
ps -eo pid,args | grep -E '[X]org|[l]ightdm' | head
echo "--- 有哪些 X 会话 ---"
ls /tmp/.X11-unix/ 2>/dev/null
echo "=== DONE ==="
