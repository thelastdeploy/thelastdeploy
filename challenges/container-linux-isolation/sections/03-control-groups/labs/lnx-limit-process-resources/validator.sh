#!/bin/bash
set -euo pipefail

TARGET="$HOME/cgroup-test/limits_summary.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "PROCESS_RESOURCES_LIMITED_VIA_CGROUP" "$TARGET"; then
    echo "FAIL: $TARGET missing 'PROCESS_RESOURCES_LIMITED_VIA_CGROUP'."
    exit 1
fi

echo "PASS: Process resource limiting with cgroups verified."
exit 0
