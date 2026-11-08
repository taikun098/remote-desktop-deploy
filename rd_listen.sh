#!/bin/bash
echo "=== rustdesk listening ports ==="
ss -tlnp | grep -i rustdesk || echo "no tcp listen found"
echo "=== all listen (any proc) top ==="
ss -tlnp | grep -E '2111|2116' || echo "no 2111x listen"
echo "=== password field in config (root service) ==="
grep -E "^(password|enc_id)" /root/.config/rustdesk/RustDesk.toml 2>/dev/null | sed 's/= .*/= <set>/'
echo "=== rustdesk svc ==="
systemctl is-active rustdesk
