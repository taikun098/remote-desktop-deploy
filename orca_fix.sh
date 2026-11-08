#!/bin/bash
echo "=== 解包 OrcaSlicer AppImage 到 /opt/orcaslicer/squashfs-root ==="
rm -rf /opt/orcaslicer/squashfs-root 2>/dev/null
cd /opt/orcaslicer && /opt/orcaslicer/OrcaSlicer.AppImage --appimage-extract >/tmp/orca_x.log 2>&1
echo "exit=$?"
ls /opt/orcaslicer/squashfs-root 2>/dev/null | head
echo "=== 找主二进制 ==="
find /opt/orcaslicer/squashfs-root -maxdepth 3 -type f \( -name 'orca-slicer' -o -name 'OrcaSlicer' -o -name 'orca_slicer' \) 2>/dev/null | head
BIN=$(find /opt/orcaslicer/squashfs-root -type f -executable -name '*slicer*' 2>/dev/null | grep -vE '\.so|apprun|wrapper' | head -1)
echo "BIN=$BIN"
if [ -z "$BIN" ]; then BIN=$(find /opt/orcaslicer/squashfs-root -type f -executable 2>/dev/null | grep -viE '\.so|\.png|\.svg' | head -1); echo "BIN2=$BIN"; fi
echo "=== 确认 squashfs-root 里的 AppRun ==="
ls -la /opt/orcaslicer/squashfs-root/AppRun 2>/dev/null
ls /opt/orcaslicer/squashfs-root/usr/bin 2>/dev/null | head
echo "=== 替换 /usr/local/bin/orcaslicer 为解包启动器 ==="
echo "当前: $(ls -l /usr/local/bin/orcaslicer 2>/dev/null)"
echo 1 | sudo -S rm -f /usr/local/bin/orcaslicer 2>/dev/null
echo 1 | sudo -S tee /usr/local/bin/orcaslicer >/dev/null <<'EOF'
#!/bin/bash
# OrcaSlicer 解包启动器（绕过 FUSE）
exec /opt/orcaslicer/squashfs-root/AppRun "$@"
EOF
echo 1 | sudo -S chmod +x /usr/local/bin/orcaslicer
echo "=== 测试启动（:0, 10秒）==="
export DISPLAY=:0
echo 1 | sudo -S -u user env DISPLAY=:0 XAUTHORITY=/home/user/.Xauthority \
  timeout 10 /usr/local/bin/orcaslicer 2>/tmp/orca_new.log; echo "launch exit=$?"
pgrep -af -i orca-slicer | head -2 || echo "(无 orca 进程)"
tail -5 /tmp/orca_new.log 2>/dev/null
echo "=== DONE ==="
