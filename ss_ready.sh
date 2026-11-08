#!/bin/bash
timeout 40 bash -c '
echo "=== 现有串流/远程工具 ==="
which sunshine moonlight 2>/dev/null || echo "(无 sunshine/moonlight)"
echo "=== VAAPI 编码能力（RX580 硬件编码）==="
which vainfo >/dev/null 2>&1 && vainfo 2>/dev/null | grep -iE "H.264|HEVC|VAProfile.*Enc" | head -12 || echo "(vainfo 未装)"
echo "=== libva / mesa-va-drivers 是否已装 ==="
dpkg -l 2>/dev/null | grep -iE "libva2|mesa-va-drivers|libva-drm|vainfo" | awk "{print \$2,\$3}"
echo "=== 物理屏 :0 会话 ==="
echo 1 | sudo -S who 2>/dev/null
ls /tmp/.X11-unix/ 2>/dev/null
echo "=== 系统版本 ==="
grep PRETTY /etc/os-release
echo "=== DONE ==="
'
