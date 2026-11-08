#!/bin/bash
echo "=== 写正确启动器（指向 AppRun）==="
echo 1 | sudo -S tee /usr/local/bin/orcaslicer >/dev/null <<'EOF'
#!/bin/bash
# OrcaSlicer 解包启动器（绕过 FUSE）
export APPDIR=/opt/orcaslicer/squashfs-root
exec /opt/orcaslicer/squashfs-root/AppRun "$@"
EOF
echo 1 | sudo -S chmod +x /usr/local/bin/orcaslicer
cat /usr/local/bin/orcaslicer
echo "=== 测试启动（:0, 15秒）==="
export DISPLAY=:0
echo 1 | sudo -S -u user env DISPLAY=:0 XAUTHORITY=/home/user/.Xauthority \
  timeout 15 /usr/local/bin/orcaslicer 2>/tmp/orca_f3.log; echo "launch_exit=$?"
pgrep -af -i 'orca-slicer|orca_slicer' | grep -vE 'bash|grep' | head -3 || echo "(无 orca 进程)"
echo "--- 日志尾部 ---"
tail -6 /tmp/orca_f3.log 2>/dev/null
echo "=== DONE ==="
