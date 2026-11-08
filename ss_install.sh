#!/bin/bash
timeout 90 bash -c '
echo "=== 1) 下载 Sunshine deb（走代理）==="
export http_proxy=http://192.168.0.6:7897 https_proxy=http://192.168.0.6:7897
curl -fsSL -o /tmp/sunshine.deb \
  "https://github.com/LizardByte/Sunshine/releases/download/v2025.628.4510/sunshine-ubuntu-24.04-amd64.deb" 2>/tmp/curl.err && echo "下载成功: $(du -h /tmp/sunshine.deb | cut -f1)" || { echo "下载失败"; cat /tmp/curl.err; exit 1; }
echo "=== 2) 安装 deb（apt 自动拉依赖）==="
echo 1 | sudo -S apt-get install -y /tmp/sunshine.deb >/tmp/apt_sunshine.log 2>&1 && echo "安装完成 ✅" || { echo "安装失败，看日志尾部:"; tail -20 /tmp/apt_sunshine.log; }
echo "=== 3) 安装后确认 ==="
which sunshine 2>/dev/null
echo 1 | sudo -S systemctl list-unit-files 2>/dev/null | grep -i sunshine
echo "=== 4) 启用并启动服务 ==="
echo 1 | sudo -S systemctl enable sunshine 2>&1 | tail -1
echo 1 | sudo -S systemctl restart sunshine 2>&1 | tail -1
sleep 3
echo "--- 服务状态 ---"
echo 1 | sudo -S systemctl is-active sunshine 2>/dev/null
echo "=== 5) 端口监听（47990 web / 48010 串流）==="
echo 1 | sudo -S ss -tlnp 2>/dev/null | grep -E "47990|48010" | head
echo "=== 6) ufw 防火墙状态 ==="
ufw status 2>/dev/null | head -3
echo "=== 7) Sunshine 进程与版本 ==="
pgrep -af sunshine | head -2
sunshine --version 2>&1 | head -1 || echo "(sunshine --version 无输出)"
echo "=== DONE ==="
'
