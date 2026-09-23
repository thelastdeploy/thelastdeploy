#!/bin/bash
set -euo pipefail

SVC="$HOME/timer-test/maint.service"
TIMER="$HOME/timer-test/maint.timer"

if [ ! -f "$SVC" ] || [ ! -f "$TIMER" ]; then
    echo "FAIL: $SVC or $TIMER does not exist."
    exit 1
fi

if ! grep -q "Type=oneshot" "$SVC"; then
    echo "FAIL: $SVC missing 'Type=oneshot'."
    exit 1
fi

if ! grep -q "OnCalendar=" "$TIMER"; then
    echo "FAIL: $TIMER missing 'OnCalendar=' directive."
    exit 1
fi

echo "PASS: systemd timer unit creation verified."
exit 0
