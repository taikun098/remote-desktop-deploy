#!/bin/bash
echo "=== 测试：不带 network-secret 连接 60.31.207.20 ==="
rm -f /tmp/et_nosec.log
nohup /usr/local/bin/easytier-core --network-name lw -i 10.1.0.20 \
  -p tcp://60.31.207.20:11011 --instance-name g01 \
  > /tmp/et_nosec.log 2>&1 &
EPID=$!
sleep 20
echo "=== peer 状态 ==="
timeout 8 /usr/local/bin/easytier-cli peer 2>&1 | head -20
echo "=== 是否稳定（连接是否保持）==="
grep -c 'peer conn is closed' /tmp/et_nosec.log
grep -iE 'new peer connection added|peer connection removed|connect to peer error|handshake response' /tmp/et_nosec.log | tail -6
echo "=== 尾部 ==="
tail -4 /tmp/et_nosec.log
kill $EPID 2>/dev/null; sleep 1; pkill -f 'easytier-core' 2>/dev/null || true
echo done
