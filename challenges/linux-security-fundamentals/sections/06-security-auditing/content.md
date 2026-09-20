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
