#!/bin/bash
echo "=== rustdesk 服务状态 ==="
systemctl is-active rustdesk.service 2>/dev/null || systemctl is-active rustdesk 2>/dev/null
echo "=== rustdesk 进程 ==="
ps -eo pid,args | grep '[r]ustdesk' | head -3
echo "=== 监听的 rustdesk 端口 (ss) ==="
ss -tlnp 2>/dev/null | grep -iE '2111[4-9]' || echo "(无 2111x 监听)"
ss -ulnp 2>/dev/null | grep -iE '2111[4-9]' || echo "(无 UDP 2111x)"
echo "=== 所有监听端口（找 rustdesk 相关）==="
ss -tlnp 2>/dev/null | grep rustdesk || echo "(no rustdesk tcp listen)"
ss -ulnp 2>/dev/null | grep rustdesk || echo "(no rustdesk udp listen)"
echo "=== RustDesk 配置（中继/密钥）==="
sudo -n cat /root/.config/rustdesk/RustDesk.toml 2>/dev/null | grep -iE 'rendezvous|relay|key|secret|id_server|relay_server|direct' | head -30
echo "=== DONE ==="
