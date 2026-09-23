#!/bin/bash
set -euo pipefail

UNIT="$HOME/unit-test/custom-app.service"

if [ ! -f "$UNIT" ]; then
    echo "FAIL: $UNIT does not exist."
    exit 1
fi

if ! grep -q "^\[Unit\]" "$UNIT" || ! grep -q "^\[Service\]" "$UNIT" || ! grep -q "^\[Install\]" "$UNIT"; then
    echo "FAIL: $UNIT missing required section headers ([Unit], [Service], [Install])."
    exit 1
fi

if ! grep -q "ExecStart=" "$UNIT" || ! grep -q "Restart=on-failure" "$UNIT"; then
    echo "FAIL: $UNIT missing required ExecStart or Restart directive."
    exit 1
fi

echo "PASS: Custom unit file structure verified."
exit 0
