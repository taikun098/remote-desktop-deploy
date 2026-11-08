#!/bin/bash
timeout 40 bash -c '
echo "=== 写同步脚本 /usr/local/bin/ll-desktop-sync.sh ==="
echo 1 | sudo -S tee /usr/local/bin/ll-desktop-sync.sh >/dev/null <<"EOF"
#!/bin/bash
# 同步玲珑应用 desktop 图标到 user 桌面（仅新增，不覆盖已有）
SRC=/var/lib/linglong/entries/apps/share/applications
DST=/home/user/Desktop
[ -d "$SRC" ] || exit 0
[ -d "$DST" ] || mkdir -p "$DST"
for f in "$SRC"/*.desktop; do
  [ -e "$f" ] || continue
  base=$(basename "$f")
  if [ ! -e "$DST/$base" ]; then
    cp "$f" "$DST/$base" 2>/dev/null
    chmod +x "$DST/$base" 2>/dev/null
    chown user:user "$DST/$base" 2>/dev/null
  fi
done
EOF
echo 1 | sudo -S chmod +x /usr/local/bin/ll-desktop-sync.sh
echo "=== 写 systemd service + timer ==="
echo 1 | sudo -S tee /etc/systemd/system/ll-desktop-sync.service >/dev/null <<"EOF"
[Unit]
Description=Sync linglong app desktop icons to user Desktop
After=local-fs.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/ll-desktop-sync.sh
EOF
echo 1 | sudo -S tee /etc/systemd/system/ll-desktop-sync.timer >/dev/null <<"EOF"
[Unit]
Description=Periodic sync of linglong desktop icons

[Timer]
OnCalendar=*:0/2
Persistent=true

[Install]
WantedBy=timers.target
EOF
echo 1 | sudo -S systemctl daemon-reload
echo 1 | sudo -S systemctl enable --now ll-desktop-sync.timer 2>&1 | tail -2
echo "=== 立即跑一次并验证 ==="
echo 1 | sudo -S /usr/local/bin/ll-desktop-sync.sh
echo "同步后桌面 desktop 文件:"
ls /home/user/Desktop/*.desktop 2>/dev/null | grep -iE "wechat|bili|motrix|seal"
echo "=== timer 状态 ==="
systemctl is-active ll-desktop-sync.timer 2>/dev/null
echo "=== DONE ==="
'
