#!/bin/bash
set -euo pipefail

CONF="$HOME/idempotent-test/app.conf"
SCRIPT="$HOME/idempotent-test/deploy.sh"

if [ ! -f "$SCRIPT" ] || [ ! -x "$SCRIPT" ]; then
    echo "FAIL: $SCRIPT does not exist or is not executable."
    exit 1
fi

# Run script again to test idempotency
"$SCRIPT"

TIMEOUT_COUNT=$(grep -c "^TIMEOUT=30" "$CONF" || true)
CONN_COUNT=$(grep -c "^MAX_CONNECTIONS=200" "$CONF" || true)

if [ "$TIMEOUT_COUNT" -ne 1 ]; then
    echo "FAIL: Expected exactly 1 'TIMEOUT=30' entry, found $TIMEOUT_COUNT."
    exit 1
fi

if [ "$CONN_COUNT" -ne 1 ]; then
    echo "FAIL: Expected exactly 1 'MAX_CONNECTIONS=200' entry, found $CONN_COUNT."
    exit 1
fi

echo "PASS: Idempotent configuration script verified."
exit 0
