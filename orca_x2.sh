#!/bin/bash
echo "=== 解包日志 ==="
cat /tmp/orca_x.log 2>/dev/null | head -20
echo "=== 手动重试解包（到 /opt/orcaslicer/xr）==="
cd /tmp
rm -rf /opt/orcaslicer/squashfs-root 2>/dev/null
mkdir -p /opt/orcaslicer/xr && cd /opt/orcaslicer/xr
APPIMAGE_EXTRACT_AND_RUN=1 /opt/orcaslicer/OrcaSlicer.AppImage --appimage-extract 2>&1 | head -15
echo "extract exit=${PIPESTATUS[0]}"
ls -la /opt/orcaslicer/xr/squashfs-root 2>/dev/null | head -6
echo "=== 若失败, 用 unsquashfs 直接解开 ==="
which unsquashfs 2>/dev/null || echo "(无 unsquashfs，可 apt 装 squashfs-tools)"
echo "=== 原 wrapper 内容（.steam 无关，看 /usr/local/bin 残留）==="
ls -la /usr/local/bin/orcaslicer 2>/dev/null
echo "=== DONE ==="
