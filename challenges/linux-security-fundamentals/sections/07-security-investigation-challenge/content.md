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

---

## Lab Tasks

### Task 1: Investigate and Remediate Security Privilege Breach (`lnx-investigate-permission-breach`)
1. Start the lab:
   ```bash
   tld start lnx-investigate-permission-breach
   ```
2. Investigate the security vulnerabilities present across `$HOME/security-breach/`.
3. Secure the secret key at `$HOME/security-breach/config/db_pass.key` by changing its permissions to `600`.
4. Remove the SUID bit from `$HOME/security-breach/bin/custom_helper` (change permissions to `0755` or `u-s`).
5. Remove the insecure `NOPASSWD: ALL` rule from `$HOME/security-breach/sudoers.d/app_user`.
6. Output a post-mortem incident report at `$HOME/security-breach/breach_report.txt` containing:
   - `VULNERABILITY_VECTOR: SUDO_NOPASSWD`
   - `BREACH_REMEDIATION: COMPLETED`
7. Validate your solution:
   ```bash
   tld check
   ```
