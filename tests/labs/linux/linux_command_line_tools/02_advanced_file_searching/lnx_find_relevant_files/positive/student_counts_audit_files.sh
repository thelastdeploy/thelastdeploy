#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Locate relevant audit files using find predicates
# Module: linux-command-line-tools
# Section: 02-advanced-file-searching
# Lab ID: lnx-find-relevant-files
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-find-relevant-files"

# Step 1: Student inspects the audits directory
student_exec "ls -la ~/search-test/audits" \
    --desc "Student inspects contents of ~/search-test/audits" \
    --expect-exit 0 \
    --expect-stdout "sec_01.audit"

# Step 2: Student uses find to locate only .audit files
student_exec "find \$HOME/search-test/audits -name '*.audit'" \
    --desc "Student searches for .audit files using find" \
    --expect-exit 0 \
    --expect-stdout "sec_01.audit"

# Step 3: Student counts matching audit files by piping find to wc -l
student_exec "find \$HOME/search-test/audits -name '*.audit' | wc -l" \
    --desc "Student calculates total count of .audit files" \
    --expect-exit 0 \
    --expect-stdout "3"

# Step 4: Student saves the count to audit_count.txt
student_exec "find \$HOME/search-test/audits -name '*.audit' | wc -l > ~/search-test/audit_count.txt" \
    --desc "Student saves count '3' to ~/search-test/audit_count.txt" \
    --expect-exit 0

# Step 5: Intermediate verification by reading back audit_count.txt
student_exec "cat ~/search-test/audit_count.txt" \
    --desc "Student confirms the content of audit_count.txt" \
    --expect-exit 0 \
    --expect-stdout "3"

# Step 6: Student runs the TLD validator check
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Audit files counted correctly."
