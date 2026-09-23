#!/bin/bash
set -euo pipefail

TARGET="$HOME/systemd-test/units_info.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "^SERVICES_COUNT: [0-9]" "$TARGET"; then
    echo "FAIL: $TARGET missing valid 'SERVICES_COUNT: ' entry."
    exit 1
fi

if ! grep -q "^TIMERS_COUNT: [0-9]" "$TARGET"; then
    echo "FAIL: $TARGET missing valid 'TIMERS_COUNT: ' entry."
    exit 1
fi

echo "PASS: systemd unit inspection verified."
exit 0
