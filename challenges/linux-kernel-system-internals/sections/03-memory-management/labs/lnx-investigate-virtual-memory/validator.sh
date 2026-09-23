#!/usr/bin/env bash
set -euo pipefail

if [ -f "$HOME/mem-internals/vma_analysis.txt" ] && grep -q "VIRTUAL_MEMORY_ADDRESS_MAPPINGS_ANALYZED" "$HOME/mem-internals/vma_analysis.txt"; then
    echo "PASS: Investigate Virtual Memory Mappings verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Investigate Virtual Memory Mappings."
    exit 1
fi
