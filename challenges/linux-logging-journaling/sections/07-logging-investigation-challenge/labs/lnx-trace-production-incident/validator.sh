#!/bin/bash
set -euo pipefail

REPORT_FILE="$HOME/incident-investigation/incident_report.txt"

if [ ! -f "$REPORT_FILE" ]; then
    echo "FAIL: $REPORT_FILE does not exist."
    exit 1
fi

CONTENT=$(cat "$REPORT_FILE")

if ! echo "$CONTENT" | grep -q "INCIDENT_TIMESTAMP:"; then
    echo "FAIL: $REPORT_FILE missing 'INCIDENT_TIMESTAMP:' entry."
    exit 1
fi

if ! echo "$CONTENT" | grep -q "FAILED_SERVICE: order-api.service"; then
    echo "FAIL: $REPORT_FILE missing 'FAILED_SERVICE: order-api.service'."
    exit 1
fi

if ! echo "$CONTENT" | grep -Eq "ROOT_CAUSE: (OUT_OF_MEMORY|OOM)"; then
    echo "FAIL: $REPORT_FILE missing 'ROOT_CAUSE: OUT_OF_MEMORY'."
    exit 1
fi

echo "PASS: Production incident logging investigation capstone verified."
exit 0
