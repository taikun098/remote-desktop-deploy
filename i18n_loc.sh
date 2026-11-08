#!/bin/bash
for i in $(seq 1 30); do
  if ! systemctl is-active i18n-install >/dev/null 2>&1; then break; fi
  sleep 5
done
echo "=== apt 日志尾部 ==="
tail -12 /tmp/i18n_apt.log 2>/dev/null
echo "=== language-pack-zh 已装？ ==="
dpkg -l 2>/dev/null | grep language-pack-zh
echo "=== zh_CN locale 已生成？ ==="
locale -a 2>/dev/null | grep -i zh || echo "(zh_CN 未生成)"
echo "=== 写 /etc/default/locale 为中文 ==="
cat > /etc/default/locale <<'EOF'
LANG=zh_CN.UTF-8
LANGUAGE=zh_CN:zh:en
LC_NUMERIC=zh_CN.UTF-8
LC_TIME=zh_CN.UTF-8
LC_MONETARY=zh_CN.UTF-8
LC_PAPER=zh_CN.UTF-8
LC_NAME=zh_CN.UTF-8
LC_ADDRESS=zh_CN.UTF-8
LC_TELEPHONE=zh_CN.UTF-8
LC_MEASUREMENT=zh_CN.UTF-8
LC_IDENTIFICATION=zh_CN.UTF-8
EOF
echo "--- 写入结果 ---"
cat /etc/default/locale
echo "=== 同步到 /etc/environment ==="
grep -q 'LANG=zh_CN' /etc/environment 2>/dev/null || echo 'LANG=zh_CN.UTF-8' >> /etc/environment
grep -q 'LANGUAGE' /etc/environment 2>/dev/null || echo 'LANGUAGE=zh_CN:zh:en' >> /etc/environment
cat /etc/environment
echo "=== 立即生效验证（新 shell 内测试中文 locale）==="
locale-gen zh_CN.UTF-8 2>&1 | tail -2
echo "=== DONE ==="
