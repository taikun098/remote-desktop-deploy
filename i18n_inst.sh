#!/bin/bash
set -x
# 后台装中文语言包，防 SSH 断开
systemctl reset-failed i18n-install 2>/dev/null
echo 1 | sudo -S systemd-run --unit=i18n-install --collect --setenv=DEBIAN_FRONTEND=noninteractive \
  bash -c 'apt-get install -y language-pack-zh-hans > /tmp/i18n_apt.log 2>&1' 2>&1
echo "已提交中文语言包安装任务"
