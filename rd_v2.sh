#!/bin/bash
echo "=== 21118 是否监听（TCP/UDP）==="
ss -tlnp 2>/dev/null | grep 21118 || echo "TCP 21118 未监听"
ss -ulnp 2>/dev/null | grep 21118 || echo "UDP 21118 未监听"
echo "=== 本机 21118 直连握手 ==="
timeout 3 bash -c 'exec 3<>/dev/tcp/127.0.0.1/21118; head -c 12 <&3 | xxd' 2>&1 || echo "(21118 无响应——直连口不返回明文 banner 属正常)"
echo "=== rustdesk 到 yc 的 UDP 心跳（21116/21118）==="
ss -unp 2>/dev/null | grep -E '2111[68]|36.102.85.112' | head
echo "=== --server 日志新增（注册是否完成）==="
LOG=/home/user/.local/share/logs/RustDesk/server/rustdesk_rCURRENT.log
stat -c 'size=%s mtime=%y' $LOG
echo "--- 是否有 register / hbbs 放行 / online 相关 ---"
grep -iE 'register|approved|online|direct.*ok|listening' $LOG 2>/dev/null | tail -8
echo "=== 全部 rustdesk 监听端口 ==="
ps -eo pid,args | grep '[r]ustdesk --server' | awk '{print $1}' | while read p; do
  ss -tlnp 2>/dev/null | grep "pid=$p"
  ss -ulnp 2>/dev/null | grep "pid=$p"
done
echo "=== DONE ==="
