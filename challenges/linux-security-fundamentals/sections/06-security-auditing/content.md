# System Security Auditing

A security audit systematically evaluates a Linux system's security posture by analyzing user account configurations, file permission masks, sudo delegation rules, and running process ownership.

## 1. Key Audit Checkpoints

1. **User Accounts**:
   - Check for non-root accounts assigned `UID=0` in `/etc/passwd`:
     ```bash
     awk -F: '($3 == 0) { print $1 }' /etc/passwd
     ```
2. **Passwordless Sudo Delegation**:
   - Search `/etc/sudoers` and `/etc/sudoers.d/` for `NOPASSWD: ALL` entries.
3. **File Permission Misconfigurations**:
   - Search system paths for world-writable configuration files and un-audited SUID binaries.
4. **Network Listeners & Processes**:
   - List active network listening ports (`ss -tulpn`) and verify process owners.

## 2. Generating Security Audit Reports

Audits should produce clear, repeatable findings reports detailing identified vulnerabilities rather than executing blind modifications.

---

## Lab Tasks

### Task 1: Perform System Security Baseline Audit (`lnx-audit-system-security`)
1. Start the lab:
   ```bash
   tld start lnx-audit-system-security
   ```
2. Perform a comprehensive system security baseline audit.
3. Create an audit execution script at `$HOME/sec-test/audit_script.sh` that checks file permissions and writes findings to `$HOME/sec-test/audit_findings.txt`.
4. Validate your solution:
   ```bash
   tld check
   ```
