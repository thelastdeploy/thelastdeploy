#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Locate System Configuration Files
# Module: linux-environment-configuration
# Section: 03-application-configuration
# Lab ID: lnx-find-application-configuration
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-find-application-configuration"

# Step 1: Student inspects the sys_etc directory using find
student_exec "find ~/env-test/sys_etc -type f -name '*.conf'" \
    --desc "Student searches for .conf files inside sys_etc" \
    --expect-exit 0 \
    --expect-stdout "nginx.conf"

# Step 2: Student writes matching configuration paths to config_files.list
student_exec "find ~/env-test/sys_etc -type f -name '*.conf' > ~/env-test/config_files.list" \
    --desc "Student outputs configuration file paths to config_files.list" \
    --expect-exit 0

# Step 3: Student verifies the contents of config_files.list
student_exec "cat ~/env-test/config_files.list" \
    --desc "Student verifies discovered config file list" \
    --expect-exit 0 \
    --expect-stdout "redis.conf"

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Configuration files discovery list verified."
