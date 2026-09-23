#!/usr/bin/env bash
set -euo pipefail

if [ -f "$HOME/mem-internals/page_fault_slab.log" ] && grep -q "PAGE_FAULTS_AND_SLAB_ALLOCATOR_TRACED" "$HOME/mem-internals/page_fault_slab.log"; then
    echo "PASS: Trace Memory Management & Page Faults verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Trace Memory Management & Page Faults."
    exit 1
fi
