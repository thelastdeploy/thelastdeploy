#!/bin/bash
set -euo pipefail

UNIT="$HOME/prod-service-test/prod-api.service"

if [ ! -f "$UNIT" ]; then
    echo "FAIL: $UNIT does not exist."
    exit 1
fi

if ! grep -q "EnvironmentFile=" "$UNIT"; then
    echo "FAIL: $UNIT missing 'EnvironmentFile=' directive."
    exit 1
fi

if ! grep -q "Restart=always" "$UNIT"; then
    echo "FAIL: $UNIT missing 'Restart=always' directive."
    exit 1
fi

if ! grep -q "LimitNOFILE=65536" "$UNIT"; then
    echo "FAIL: $UNIT missing 'LimitNOFILE=65536' resource limit."
    exit 1
fi

if ! grep -q "NoNewPrivileges=true" "$UNIT"; then
    echo "FAIL: $UNIT missing 'NoNewPrivileges=true' security directive."
    exit 1
fi

echo "PASS: Production systemd service hardening verified."
exit 0
