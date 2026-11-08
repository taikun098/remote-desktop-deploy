#!/bin/bash
set -e
echo "=== 安装 VAAPI 驱动 + vainfo ==="
echo 1 | sudo -S apt-get install -y --no-install-recommends mesa-va-drivers vainfo 2>&1 | tail -8
echo "=== 验证 vainfo（lightdm render 访问）==="
echo 1 | sudo -S timeout 10 vainfo 2>&1 | head -20 || echo "(vainfo 仍不可用)"
echo "=== DONE ==="
