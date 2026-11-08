#!/bin/bash
echo "=== 开 debug 日志观察 60.31.207.20 断开原因 ==="
rm -f /tmp/et_debug.log
RUST_LOG=debug nohup /usr/local/bin/easytier-core --network-name lw --network-secret 'admin@8897802' -i 10.1.0.20 \
  -p tcp://60.31.207.20:11011 --instance-name g01 \
  > /tmp/et_debug.log 2>&1 &
EPID=$!
sleep 18
echo "=== debug 日志（只看关键段）==="
grep -iE 'secret|auth|network.*(mismatch|invalid|reject|error)|virtual|handshake|drop|refuse|version|proto' /tmp/et_debug.log | tail -30
echo "=== 原始 tail 30 ==="
tail -30 /tmp/et_debug.log
kill $EPID 2>/dev/null; sleep 1; pkill -f 'easytier-core' 2>/dev/null || true
echo done
