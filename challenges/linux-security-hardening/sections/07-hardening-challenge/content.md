# Compromised Server Hardening Capstone Challenge

In this capstone challenge, you inherit an insecure Linux server containing multiple security vulnerabilities: root SSH login enabled, unrestricted sudo NOPASSWD entries, world-writable sensitive files, and unneeded network services exposed. Your task is to perform complete system hardening and verify security compliance.

---

## Hardening Execution Plan

1. **Access Controls**: Disable root SSH login, enforce password policies, and restrict sudoers.
2. **Filesystem**: Fix permissions on `/etc/shadow` and strip unauthorized SUID flags.
3. **Services**: Apply systemd sandboxing and disable non-essential daemons.
4. **Verification**: Execute compliance audit to verify all security requirements pass.

---

## Summary

Completing the capstone validates your capability to audit, remediate, and harden production Linux servers against real-world attack vectors.

---

## Lab Tasks

### Task 1: Harden Compromised Linux Server Capstone (`lnx-harden-compromised-server`)
1. Start the lab:
   ```bash
   tld start lnx-harden-compromised-server
   ```
2. Create directory `$HOME/sec-challenge`.
3. Write server hardening remediation script `$HOME/sec-challenge/harden_server.sh`.
4. Write output summary line `COMPROMISED_SERVER_HARDENED` into `$HOME/sec-challenge/hardening.log`.
5. Validate your solution:
   ```bash
   tld check
   ```
