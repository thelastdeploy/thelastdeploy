#!/usr/bin/env bash
set -euo pipefail

REPORT_FILE="$HOME/mon-challenge/incident/report.txt"

if [ ! -f "$REPORT_FILE" ]; then
    echo "ERROR: Report file $REPORT_FILE not found!"
    exit 1
fi

if ! grep -q "STATUS: RESOLVED" "$REPORT_FILE"; then
    echo "ERROR: STATUS: RESOLVED not found in $REPORT_FILE."
    exit 1
fi

if ! grep -q "ROGUE_PID: 7782" "$REPORT_FILE"; then
    echo "ERROR: ROGUE_PID: 7782 not found in $REPORT_FILE."
    exit 1
fi

if ! grep -q "BOTTLENECK: cpu_memory" "$REPORT_FILE"; then
    echo "ERROR: BOTTLENECK: cpu_memory not found in $REPORT_FILE."
    exit 1
fi

echo "SUCCESS: Overloaded server incident diagnosed and report resolved."
exit 0
