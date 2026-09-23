#!/bin/bash
set -euo pipefail

TARGET="$HOME/evidence-test/proc_net_evidence.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "PROC_NET_EVIDENCE_COLLECTED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'PROC_NET_EVIDENCE_COLLECTED'."
    exit 1
fi

echo "PASS: Volatile process and network evidence collection verified."
exit 0
