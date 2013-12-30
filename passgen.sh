( dd if=/dev/urandom bs=256 count=1 2>/dev/null |uuencode -m - | tail -n2 | tr -dc '0-9a-zA-Z' | head -c 8 ); echo ""
