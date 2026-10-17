#!/usr/bin/env bash
set -euo pipefail

TARGET="$HOME/kernel-tracing/trace_analysis.log"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if [ ! -s "$TARGET" ]; then
    echo "FAIL: $TARGET is empty."
    exit 1
fi

if ! grep -q "KERNEL_TRACEFS_AND_FTRACE_EVENTS_EXAMINED" "$TARGET"; then
    echo "FAIL: Requirement not met for Trace Kernel System Behavior."
    exit 1
fi

echo "PASS: Trace Kernel System Behavior verified successfully."
exit 0
