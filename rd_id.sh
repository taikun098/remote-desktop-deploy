#!/bin/bash
echo "=== 当前设备 ID (enc_id) ==="
grep -E '^enc_id' /home/user/.config/rustdesk/RustDesk.toml 2>/dev/null | head -1
grep -E '^enc_id' /root/.config/rustdesk/RustDesk.toml 2>/dev/null | head -1
echo "=== key 字段来源确认（RustDesk.toml 是否有 key_pair 无关）==="
echo "=== 21116 最终确认 ==="
ss -tlnp 2>/dev/null | grep 21116 || echo "TCP未监听"
echo "=== DONE ==="
