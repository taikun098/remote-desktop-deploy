#!/bin/bash
echo "=== easytier 服务日志（最近连接/错误）==="
sudo -n journalctl -u easytier.service --no-pager -n 200 2>/dev/null | grep -iE 'connect|handshake|peer|secret|error|timeout|removed|added' | tail -25
echo "=== 最近 8 条原始日志 ==="
sudo -n journalctl -u easytier.service --no-pager -n 8 2>/dev/null
echo "=== peer 状态 ==="
timeout 8 /usr/local/bin/easytier-cli peer 2>&1 | head -15
echo "=== DONE ==="
