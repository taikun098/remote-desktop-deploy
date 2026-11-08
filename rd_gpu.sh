#!/bin/bash
echo "=== GPU 硬件 ==="
lspci -nnk 2>/dev/null | grep -iA4 'VGA\|Display controller'
echo "=== amdgpu 驱动 ==="
lsmod 2>/dev/null | grep -i amdgpu | head -3 || echo "(amdgpu 未加载)"
echo "=== /dev/dri ==="
ls -la /dev/dri/ 2>/dev/null
echo "=== lightdm 是否在 render/video 组 ==="
id lightdm
echo "=== vainfo（若有）==="
command -v vainfo >/dev/null && vainfo 2>&1 | head -20 || echo "(vainfo 未装)"
echo "=== Xorg 数量与显示 ==="
ps -eo pid,args | grep '[X]org'
echo "=== rustdesk 用的 display 上有没有可用 GPU 会话 ==="
sudo -u lightdm env DISPLAY=:0 XAUTHORITY=/var/lib/lightdm/.Xauthority xdpyinfo 2>&1 | head -5 || echo "(DISPLAY :0 不可用/无 xdpyinfo)"
echo "=== DONE ==="
