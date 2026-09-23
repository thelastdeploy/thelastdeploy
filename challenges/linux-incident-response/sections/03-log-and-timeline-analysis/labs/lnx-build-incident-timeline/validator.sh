#!/bin/bash
set -euo pipefail

TARGET="$HOME/timeline-test/incident_timeline.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if ! grep -q "INCIDENT_TIMELINE_BUILT" "$TARGET"; then
    echo "FAIL: $TARGET missing 'INCIDENT_TIMELINE_BUILT'."
    exit 1
fi

echo "PASS: Chronological incident timeline construction verified."
exit 0
