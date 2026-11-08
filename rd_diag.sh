#!/bin/bash
SPID=$(ps -eo pid,args | grep 'rustdesk --server' | grep -v grep | awk '{print $1}' | tail -1)
echo "=== --server pid=$SPID 状态 ==="
ps -o pid,stat,wchan,etime,args -p "$SPID" 2>/dev/null || echo "无此进程"
echo "=== --server 全部 socket（tcp+udp）==="
ss -tanp 2>/dev/null | grep "pid=$SPID" || echo "(无 tcp)"
ss -uanp 2>/dev/null | grep "pid=$SPID" || echo "(无 udp)"
echo "=== root 配置是否保留 rendezvous_server（重启后被重写?）==="
sudo -n grep -cE 'rendezvous_server' /root/.config/rustdesk/RustDesk.toml
echo "=== lightdm 配置是否有网络项 ==="
sudo -n grep -E 'rendezvous_server|custom-rendezvous|^key' /var/lib/lightdm/.config/rustdesk/RustDesk.toml | sed -E "s/(key = .*)/key=[REDACTED]/" || echo "(lightdm 无网络项)"
echo "=== 服务日志完整尾部 40 行 ==="
sudo -n tail -40 /root/.local/share/logs/RustDesk/service/rustdesk_rCURRENT.log 2>/dev/null
echo "=== 全部 Xorg / 显示 ==="
ps -eo pid,args | grep '[X]org'
ls -la /tmp/.X11-unix/ 2>/dev/null
echo "=== DONE ==="
