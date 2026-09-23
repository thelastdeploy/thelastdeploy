#!/bin/bash
set -euo pipefail

TARGET="$HOME/cgroup-test/cgroup_info.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "CGROUP_HIERARCHY_EXPLORED" "$TARGET"; then
    echo "FAIL: $TARGET missing 'CGROUP_HIERARCHY_EXPLORED'."
    exit 1
fi

echo "PASS: cgroup resource control hierarchy exploration verified."
exit 0
