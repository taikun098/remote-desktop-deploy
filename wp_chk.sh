#!/bin/bash
timeout 30 bash -c '
echo "=== 拷贝日志尾 ==="
tail -15 /tmp/wp_copy.log 2>/dev/null
echo "=== 拷贝进程是否还在 ==="
pgrep -af "wp_all.txt" | grep -v "bash -c" | head -1 || echo "(拷贝已完成)"
echo "=== 壁纸目录最终统计 ==="
echo "文件数: $(ls /home/user/Videos/Hidamari/ 2>/dev/null | wc -l)"
echo "总大小: $(du -sh /home/user/Videos/Hidamari/ 2>/dev/null | awk "{print \$1}")"
echo "=== DONE ==="
'
