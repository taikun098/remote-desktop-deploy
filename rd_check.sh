#!/bin/bash
echo "=== 重启服务 ==="
systemctl restart rustdesk.service
sleep 25
echo "=== 状态 ==="
systemctl is-active rustdesk.service
echo "=== 21116 TCP/UDP 监听 ==="
ss -tlnp 2>/dev/null | grep 21116 || echo "(21116 TCP 未监听)"
ss -ulnp 2>/dev/null | grep 21116 || echo "(21116 UDP 未监听)"
echo "=== 到 yc(36.102.85.112) 的全部连接 TCP+UDP ==="
ss -tnp 2>/dev/null | grep '36.102.85.112' || echo "(无 TCP 到 yc)"
ss -unp 2>/dev/null | grep '36.102.85.112' || echo "(无 UDP 到 yc)"
echo "=== rustdesk 全部 TCP 监听 ==="
ss -tlnp 2>/dev/null | grep rustdesk || echo "(无)"
echo "=== rustdesk 全部 UDP 监听 ==="
ss -ulnp 2>/dev/null | grep rustdesk || echo "(无)"
echo "=== 进程 ==="
ps -eo pid,args | grep '[r]ustdesk' | grep -v check-hwcodec
echo "=== 日志尾部 25 ==="
tail -25 /root/.local/share/logs/RustDesk/service/rustdesk_rCURRENT.log 2>/dev/null
echo "=== DONE ==="
