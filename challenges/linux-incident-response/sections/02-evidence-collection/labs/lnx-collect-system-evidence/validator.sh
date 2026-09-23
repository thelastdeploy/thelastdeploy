#!/bin/bash
set -euo pipefail

TARGET="$HOME/evidence-test/system_evidence.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "SYSTEM_EVIDENCE_COLLECTED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'SYSTEM_EVIDENCE_COLLECTED'."
    exit 1
fi

echo "PASS: System file and environment evidence collection verified."
exit 0
