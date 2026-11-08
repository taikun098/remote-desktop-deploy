#!/bin/bash
timeout 40 bash -c '
echo "=== 显卡硬件（PCI）==="
echo 1 | sudo -S lspci -nnk 2>/dev/null | grep -iA3 -E "vga|3d|display"
echo "=== 内核驱动模块 amdgpu 状态 ==="
lsmod 2>/dev/null | grep -iE "amdgpu|radeon|firmware" | head
echo "--- 模块信息 ---"
modinfo amdgpu 2>/dev/null | grep -E "^filename|^version" | head
echo "=== amdgpu 固件 ==="
ls /lib/firmware/amdgpu/ 2>/dev/null | head -8
echo "=== Xorg 驱动 ==="
ls /usr/lib/xorg/modules/drivers/ 2>/dev/null | grep -iE "amd|ati"
echo "=== 当前渲染/GPU 信息 ==="
echo 1 | sudo -S ls -l /dev/dri/ 2>/dev/null
glxinfo -B 2>/dev/null | grep -iE "OpenGL renderer|OpenGL version|direct rendering" | head || echo "(glxinfo 不可用/无DISPLAY)"
echo "=== DONE ==="
'
