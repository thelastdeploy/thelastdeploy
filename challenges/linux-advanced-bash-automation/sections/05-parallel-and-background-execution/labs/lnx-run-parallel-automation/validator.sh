#!/bin/bash
set -euo pipefail

RESULTS_DIR="$HOME/parallel-test/results"

COUNT=$(ls -1 "$RESULTS_DIR"/*.txt 2>/dev/null | wc -l)
if [ "$COUNT" -ne 5 ]; then
    echo "FAIL: Expected 5 files in $RESULTS_DIR, found $COUNT."
    exit 1
fi

if ! grep -q "SAMPLE DATA 1" "$RESULTS_DIR/f1.txt"; then
    echo "FAIL: $RESULTS_DIR/f1.txt text was not converted to uppercase."
    exit 1
fi

echo "PASS: Parallel batch processing verified."
exit 0
