#!/bin/bash
timeout 40 bash -c '
echo "=== 磁盘概览（型号/大小/格式/挂载点）==="
echo 1 | sudo -S lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINT,MODEL 2>/dev/null
echo "=== 按大小找 1.8T 级 NTFS 分区（blkid）==="
echo 1 | sudo -S blkid 2>/dev/null | grep -iE "ntfs|exfat" 
echo "=== DONE ==="
'
