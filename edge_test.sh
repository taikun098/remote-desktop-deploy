#!/bin/bash
echo "=== Edge 版本 ==="
microsoft-edge --version 2>&1
echo "=== Edge 无头冒烟测试（渲染一个简单页面）==="
timeout 25 microsoft-edge --headless --no-sandbox --disable-gpu --disable-dev-shm-usage --dump-dom "data:text/html,<html><body><h1>Hello Edge</h1></body></html>" 2>/tmp/edge_err.log | grep -o 'Hello Edge' | head -1
echo "(上行为渲染结果)"
echo "=== 中文渲染能力（检查是否输出中文）==="
timeout 25 microsoft-edge --headless --no-sandbox --disable-gpu --dump-dom "data:text/html,<meta charset=utf-8><body>中文测试</body>" 2>/dev/null | grep -o '中文测试' | head -1
echo "=== Edge 能否在 :0 启动（GUI）==="
export DISPLAY=:0
timeout 6 microsoft-edge --no-sandbox --new-window about:blank 2>/tmp/edge_gui.log & sleep 5; 
pgrep -f 'microsoft-edge --new-window' >/dev/null && echo "GUI 进程已启动" || echo "GUI 进程未检测到"
pkill -f 'microsoft-edge --new-window' 2>/dev/null
echo "--- 错误日志尾 ---"
tail -3 /tmp/edge_gui.log 2>/dev/null
echo "=== DONE ==="
