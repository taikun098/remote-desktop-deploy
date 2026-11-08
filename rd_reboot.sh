#!/bin/bash
echo "=== vainfo（确认 GPU 硬件编码可用）==="
timeout 10 sudo -u lightdm vainfo 2>&1 | grep -iE 'Driver|VAProfile|VAEntrypoint|error|vainfo: ' | head -15
echo "=== 重启 rustdesk ==="
systemctl restart rustdesk.service
echo "重启完成 pid=$(ps -eo pid,args | grep 'rustdesk --server' | grep -v grep | awk '{print $1}' | tail -1)"
echo "=== DONE ==="
