# Security Permission Breach Investigation Capstone

A shared Linux server contains an application service account (`app_user`) that has been detected executing commands with unexpected root access.

## Challenge Objective

Investigate system configurations in `$HOME/security-breach/`, audit permissions, fix security flaws, and produce a post-mortem report.

## Required Tasks

1. **Remediate World-Writable File**: Change permissions on `$HOME/security-breach/config/db_pass.key` to strict `600` mode.
2. **Remove Dangerous SUID Bit**: Strip the SUID bit from `$HOME/security-breach/bin/custom_helper` (change mode to `0755`).
3. **Restrict Sudo Access**: Remove overly permissive `NOPASSWD: ALL` rule from `$HOME/security-breach/sudoers.d/app_user`.
4. **Submit Incident Report**: Output an investigation report at `$HOME/security-breach/breach_report.txt` containing:
   - `VULNERABILITY_VECTOR: SUDO_NOPASSWD`
   - `BREACH_REMEDIATION: COMPLETED`
