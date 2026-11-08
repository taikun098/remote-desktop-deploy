#!/bin/bash
echo "=== easytier-core help ==="
easytier-core --help 2>&1 | head -50
echo "=== easytier-cli help (brief) ==="
easytier-cli --help 2>&1 | head -30
echo "=== any example config shipped ==="
find /usr/local/bin /tmp/easytier_extract -iname '*config*' -o -iname '*.toml' 2>/dev/null | head -10
echo "=== check schema via --print-default-config if exists ==="
easytier-core --print-default-config 2>&1 | head -60 || echo "(no such flag)"
