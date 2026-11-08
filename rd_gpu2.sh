#!/bin/bash
OUT=/tmp/rd_gpu2.txt
: > $OUT
echo "=== GPU ===" >> $OUT
lspci -nnk 2>/dev/null | grep -iA4 'VGA\|Display controller' >> $OUT 2>&1
echo "=== amdgpu 模块 ===" >> $OUT
lsmod 2>/dev/null | grep -i amdgpu >> $OUT 2>&1 || echo "(amdgpu 未加载)" >> $OUT
echo "=== /dev/dri ===" >> $OUT
ls -la /dev/dri/ >> $OUT 2>&1
echo "=== lightdm 组 ===" >> $OUT
id lightdm >> $OUT 2>&1
echo "=== vainfo (10s超时) ===" >> $OUT
timeout 10 vainfo >> $OUT 2>&1 || echo "(vainfo 无/超时)" >> $OUT
echo "=== Xorg 进程 ===" >> $OUT
ps -eo pid,args | grep '[X]org' >> $OUT 2>&1
echo "=== DISPLAY :0 探测 (5s) ===" >> $OUT
timeout 5 sudo -u lightdm env DISPLAY=:0 XAUTHORITY=/var/lib/lightdm/.Xauthority xdpyinfo 2>&1 | head -6 >> $OUT || echo "(DISPLAY :0 不可达)" >> $OUT
echo "=== DISPLAY :1 探测 (5s) ===" >> $OUT
timeout 5 sudo -u lightdm env DISPLAY=:1 XAUTHORITY=/var/lib/lightdm/.Xauthority xdpyinfo 2>&1 | head -6 >> $OUT || echo "(DISPLAY :1 不可达)" >> $OUT
echo "DONE" >> $OUT
chmod 644 $OUT
