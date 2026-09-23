#!/usr/bin/env bash
set -euo pipefail

if [ -f "$HOME/kernel-tracing/trace_analysis.log" ] && grep -q "KERNEL_TRACEFS_AND_FTRACE_EVENTS_EXAMINED" "$HOME/kernel-tracing/trace_analysis.log"; then
    echo "PASS: Trace Kernel System Behavior verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Trace Kernel System Behavior."
    exit 1
fi
