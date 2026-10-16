#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Install package from repository
# Module: linux-package-management
# Section: 02-installing-packages
# Lab ID: lnx-install-package-from-repository
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-install-package-from-repository"

# Step 1: Student checks if tar is present
student_exec "tar --version" \
    --desc "Student verifies tar is available" \
    --expect-exit 0 \
    --expect-stdout "tar"

# Step 2: Student saves installed status to tar_status.txt
student_exec "echo 'installed' > ~/pkg-test/tar_status.txt" \
    --desc "Student records installed status in tar_status.txt" \
    --expect-exit 0

# Step 3: Student verifies recorded status
student_exec "cat ~/pkg-test/tar_status.txt" \
    --desc "Student verifies recorded status value" \
    --expect-exit 0 \
    --expect-stdout "installed"

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Repository package installation verified."
