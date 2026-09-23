#!/bin/bash
set -euo pipefail

TARGET="$HOME/incident-capstone/post_mortem.log"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "PRODUCTION_INCIDENT_RESOLVED: SYSTEM_HEALTHY" "$TARGET"; then
    echo "FAIL: $TARGET missing 'PRODUCTION_INCIDENT_RESOLVED: SYSTEM_HEALTHY'."
    exit 1
fi

echo "PASS: Production server outage recovery capstone verified."
exit 0
