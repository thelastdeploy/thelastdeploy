#!/bin/bash
set -euo pipefail

TARGET="$HOME/param-test/processed.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

LINE1=$(sed -n '1p' "$TARGET")
LINE2=$(sed -n '2p' "$TARGET")
LINE3=$(sed -n '3p' "$TARGET")

if [ "$LINE1" != "/var/log/app/service.bak" ]; then
    echo "FAIL: Line 1 expected '/var/log/app/service.bak', got '$LINE1'."
    exit 1
fi

if [ "$LINE2" != "service.log" ]; then
    echo "FAIL: Line 2 expected 'service.log', got '$LINE2'."
    exit 1
fi

if [ "$LINE3" != "DEV_ENVIRONMENT" ]; then
    echo "FAIL: Line 3 expected 'DEV_ENVIRONMENT', got '$LINE3'."
    exit 1
fi

echo "PASS: Parameter expansion output verified successfully."
exit 0
