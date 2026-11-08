#!/bin/bash
timeout 90 bash -c '
echo "=== 1) apt 安装 flatpak（阿里云源，快）==="
echo 1 | sudo -S apt-get install -y flatpak >/tmp/apt_flatpak.log 2>&1 && echo "flatpak 安装完成 ✅" || { echo "失败:"; tail -8 /tmp/apt_flatpak.log; }
flatpak --version 2>/dev/null
echo "=== 2) 添加 flathub 源 ==="
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo 2>&1 | tail -2
echo 1 | sudo -S flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo 2>&1 | tail -2
flatpak remotes 2>/dev/null | head
echo "=== 3) 后台安装 Hidamari（走代理，防断连）==="
export http_proxy=http://192.168.0.6:7897 https_proxy=http://192.168.0.6:7897
nohup bash -c "flatpak install -y --noninteractive flathub io.github.jeffshee.Hidamari" >/tmp/hid_install.log 2>&1 &
echo "安装已在后台 PID $!，日志 /tmp/hid_install.log"
echo "=== DONE ==="
'
