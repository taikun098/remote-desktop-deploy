#!/bin/bash
# 测试 easytier-core 连接（前台试跑，验证后关闭）
set -e
echo "=== 启动 easytier-core（后台，日志到 /tmp/et_test.log）==="
rm -f /tmp/et_test.log
nohup /usr/local/bin/easytier-core \
  --network-name lw \
  --network-secret admin@8897802 \
  -i 10.1.0.20 \
  -p tcp://60.31.207.20:11011 tcp://yc.445800773.xyz:11011 \
  --instance-name g01 \
  --multi-thread true --bind-device true \
  > /tmp/et_test.log 2>&1 &
ETPID=$!
echo "easytier pid=$ETPID"
sleep 12
echo "=== 进程存活? ==="
ps -p $ETPID -o pid,cmd | tail -1 || echo "PROCESS DIED"
echo "=== 日志尾部 ==="
tail -20 /tmp/et_test.log
echo "=== tun 接口 ==="
ip addr show 2>/dev/null | grep -A3 -iE '^[0-9]+: (tun|easytier|utun)' || echo "no tun yet"
echo "=== 虚拟网络地址 ==="
ip -4 addr show 2>/dev/null | grep -E '10\.' || echo "no 10.x yet"
echo "=== peer 状态 ==="
timeout 8 /usr/local/bin/easytier-cli peer 2>&1 | head -20 || echo "(peer cmd fail)"
echo "=== 清理测试进程 ==="
kill $ETPID 2>/dev/null; sleep 1
pkill -f 'easytier-core' 2>/dev/null || true
echo "=== done ==="
