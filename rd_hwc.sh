#!/bin/bash
echo "=== 二进制中 hwcodec 相关配置键 ==="
grep -aEo 'hwcodec[^"\\x00]{0,30}|enable_hwcodec|disable_hwcodec|hwcodec_mode|use_hwcodec' /usr/share/rustdesk/lib/librustdesk.so 2>/dev/null | sort -u | head -20
echo "=== 二进制中 display 相关 / 是否支持 DISPLAY env ==="
grep -aEo 'custom-display|DISPLAY' /usr/share/rustdesk/lib/librustdesk.so 2>/dev/null | sort -u | head
echo "=== DONE ==="
