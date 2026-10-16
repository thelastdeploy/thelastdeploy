#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Identify the active interface
# Module: linux-networking
# Section: 02-ip-addresses-and-interfaces
# Lab ID: lnx-identify-active-interface
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-identify-active-interface"

# Step 1: Student checks routing table
student_exec "ip route show" \
    --desc "Student inspects kernel routing table" \
    --expect-exit 0

# Step 2: Student extracts active default interface device name
student_exec "mkdir -p ~/network-test && (ip route show | grep default | awk '{print \$5}' | head -n 1 || ip -o link show | awk -F': ' '\$2 != \"lo\" {print \$2}' | head -n 1) > ~/network-test/active_interface.txt" \
    --desc "Student extracts and saves active interface device name" \
    --expect-exit 0

# Step 3: Student verifies recorded interface name
student_exec "cat ~/network-test/active_interface.txt" \
    --desc "Student verifies recorded interface name" \
    --expect-exit 0

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Active default interface verified successfully."
