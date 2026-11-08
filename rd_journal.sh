#!/bin/bash
echo "=== journalctl rustdesk 服务日志（最近）==="
journalctl -u rustdesk --no-pager -n 60 2>/dev/null | tail -40
echo "=== journalctl 中所有 rustdesk 相关日志（最近 40 行）==="
journalctl --no-pager -n 300 2>/dev/null | grep -i rustdesk | tail -25
echo "=== DONE ==="
