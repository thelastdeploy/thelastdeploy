#!/usr/bin/env bash
set -euo pipefail

if [ -f "$HOME/mastery-perf/perf_mastery.log" ] && grep -q "LINUX_WORKLOAD_PERFORMANCE_MASTERED" "$HOME/mastery-perf/perf_mastery.log"; then
    echo "PASS: Optimize Linux Workload verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Optimize Linux Workload."
    exit 1
fi
