#!/bin/bash
echo "=== rustdesk 包信息 ==="
dpkg -l | grep -i rustdesk || echo "(dpkg 无 rustdesk)"
echo "=== 版本 ==="
/usr/bin/rustdesk --version 2>/dev/null || rustdesk --version 2>/dev/null || echo "(取版本失败)"
echo "=== 是否缓存了 deb ==="
ls -la /var/cache/apt/archives/rustdesk*.deb /tmp/rustdesk*.deb 2>/dev/null || echo "(无缓存 deb)"
echo "=== 二进制位置 ==="
ls -la /usr/bin/rustdesk /usr/share/rustdesk/rustdesk 2>/dev/null
echo "=== 服务 unit 文件 ==="
ls -la /etc/systemd/system/rustdesk.service /usr/lib/systemd/system/rustdesk.service 2>/dev/null
echo "=== 用 grep -a 从二进制找配置键名 ==="
grep -aEo 'rendezvous_server|relay_server|api_server|custom-rendezvous|custom-relay|custom-api' /usr/share/rustdesk/rustdesk 2>/dev/null | sort -u | head
echo "=== 找 key 相关键 ==="
grep -aEo 'key_confirmed|enc_id|salt|key_pair' /usr/share/rustdesk/rustdesk 2>/dev/null | sort -u | head
echo "=== DONE ==="
