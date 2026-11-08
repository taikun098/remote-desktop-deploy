#!/bin/bash
echo "=== tun0 接口 ==="
ip addr show tun0 2>/dev/null || echo "tun0 不存在"
echo "=== EasyTier 进程/服务 ==="
systemctl is-active easytier 2>/dev/null; ps -eo pid,args | grep '[e]asytier-core' | head
echo "=== 对端列表（easytier-cli）==="
which easytier-cli 2>/dev/null && easytier-cli peer 2>/dev/null | head -20 || echo "(无 easytier-cli 或未列出)"
echo "=== 本机 ping 网关 10.1.0.1 ==="
ping -c 2 -W 2 10.1.0.1 2>&1 | tail -3
echo "=== 路由表（tun0 相关）==="
ip route | grep tun0
echo "=== DONE ==="
