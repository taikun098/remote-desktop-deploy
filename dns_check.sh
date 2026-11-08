#!/bin/bash
echo "=== resolv.conf ==="
cat /etc/resolv.conf
echo "=== systemd-resolved ==="
systemctl is-active systemd-resolved 2>/dev/null || echo "not-running"
echo "=== DNS tests (getent) ==="
for d in rs.rustdesk.com rs-ny.rustdesk.com github.com mirrors.aliyun.com aliyuncs.com www.baidu.com; do
  r=$(timeout 4 getent hosts "$d" | head -1)
  echo "$d -> ${r:-FAIL}"
done
echo "=== direct nslookup via common resolvers ==="
for ns in 223.5.5.5 114.114.114.114 8.8.8.8 192.168.0.1; do
  r=$(timeout 4 nslookup rs.rustdesk.com "$ns" 2>/dev/null | grep -A2 'Name:' | grep -E 'Address' | head -1)
  echo "via $ns -> ${r:-FAIL}"
done
