#!/bin/bash
# Edge 启动包装：适配 root+VNC 无 GPU 环境，强制中文界面
exec /opt/microsoft/msedge/msedge --no-sandbox --disable-gpu --lang=zh-CN "$@"
