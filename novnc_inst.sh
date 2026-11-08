#!/bin/bash
set -x
# 用 systemd-run 后台跑 apt 安装，防 SSH 断开中断
systemctl reset-failed novnc-install 2>/dev/null
echo 1 | sudo -S systemd-run --unit=novnc-install --collect --setenv=DEBIAN_FRONTEND=noninteractive \
  bash -c 'apt-get install -y novnc websockify > /tmp/novnc_apt.log 2>&1' 2>&1
echo "已提交安装任务，稍后轮询"
