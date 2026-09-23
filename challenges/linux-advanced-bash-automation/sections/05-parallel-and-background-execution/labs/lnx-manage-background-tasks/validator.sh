#!/bin/bash
set -euo pipefail

TARGET="$HOME/bg-test/jobs_complete.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "ALL_JOBS_DONE" "$TARGET"; then
    echo "FAIL: $TARGET does not contain 'ALL_JOBS_DONE'."
    exit 1
fi

for f in t1.txt t2.txt t3.txt; do
    if [ ! -f "$HOME/bg-test/$f" ]; then
        echo "FAIL: $HOME/bg-test/$f was not created by background jobs."
        exit 1
    fi
done

echo "PASS: Background task management verified."
exit 0
