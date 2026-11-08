#!/bin/bash
echo "=== 停止服务 ==="
systemctl stop rustdesk.service
sleep 2
echo "=== 前台 strace 运行 --server（25秒，抓 connect/socket/bind）==="
rm -f /tmp/rd_strace.log /tmp/rd_srv_out.log
timeout 25 env DISPLAY=:0 XAUTHORITY=/var/lib/lightdm/.Xauthority strace -f -e trace=connect,socket,bind,openat -o /tmp/rd_strace.log /usr/share/rustdesk/rustdesk --server > /tmp/rd_srv_out.log 2>&1
echo "strace 退出码 $?，行数 $(wc -l </tmp/rd_strace.log 2>/dev/null)"
echo "=== strace 中 connect 调用（地址）==="
grep -E 'connect\(|bind\(' /tmp/rd_strace.log | head -30
echo "=== strace 中 socket(AF_INET)==="
grep -E 'socket\(AF_INET' /tmp/rd_strace.log | head -10
echo "=== --server 输出 ==="
head -40 /tmp/rd_srv_out.log
echo "=== 进程结束时监听 ==="
ss -tlnp 2>/dev/null | grep rustdesk || echo "(无)"
echo "=== DONE ==="
