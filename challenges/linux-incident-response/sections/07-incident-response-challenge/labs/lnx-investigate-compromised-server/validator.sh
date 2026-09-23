#!/bin/bash
set -euo pipefail

TARGET="$HOME/ir-capstone/forensic_investigation.log"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "FORENSIC_INVESTIGATION_COMPLETE_SYSTEM_SECURED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'FORENSIC_INVESTIGATION_COMPLETE_SYSTEM_SECURED'."
    exit 1
fi

echo "PASS: Compromised server forensic investigation capstone verified."
exit 0
