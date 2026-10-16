#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Inspect repository source configurations
# Module: linux-package-management
# Section: 06-repositories
# Lab ID: lnx-investigate-package-repositories
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-investigate-package-repositories"

# Step 1: Student inspects the sources.list file
student_exec "cat ~/repo-test/sources.list" \
    --desc "Student inspects repository sources configuration" \
    --expect-exit 0 \
    --expect-stdout "focal"

# Step 2: Student extracts the distribution codename
student_exec "grep '^deb' ~/repo-test/sources.list | head -n 1 | awk '{print \$3}' > ~/repo-test/repo_codename.txt" \
    --desc "Student extracts and saves distribution codename" \
    --expect-exit 0

# Step 3: Student verifies recorded codename
student_exec "cat ~/repo-test/repo_codename.txt" \
    --desc "Student verifies recorded codename value" \
    --expect-exit 0 \
    --expect-stdout "focal"

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Repository codename verified successfully."
