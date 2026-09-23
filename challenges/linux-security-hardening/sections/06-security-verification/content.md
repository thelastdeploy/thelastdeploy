# Security Verification & Compliance Auditing

Security verification conducts systematic compliance checks across access controls, file permissions, SSH configurations, firewall rules, and active services to validate that hardening controls remain active.

---

## 1. Compliance Verification Checklist

1. **SSH Hardening**: Verify `PermitRootLogin no` and `PasswordAuthentication no`.
2. **File Permissions**: Verify `/etc/shadow` is `600` or `640` owned by `root`.
3. **SUID Audit**: Confirm no unapproved SUID binaries exist in `/tmp` or user directories.
4. **Privilege Restriction**: Confirm `/etc/sudoers` enforces strict command lists.
5. **Services**: Verify unneeded services are disabled.

---

## 2. Automated Compliance Verification Script

```bash
#!/bin/bash
set -euo pipefail

echo "=== System Security Compliance Verification ==="

# Check SSH Root Login
if grep -E "^PermitRootLogin\s+no" /etc/ssh/sshd_config >/dev/null; then
    echo "[PASS] SSH Root Login Disabled"
else
    echo "[FAIL] SSH Root Login Enabled"
fi

# Check /etc/shadow permissions
SHADOW_PERM=$(stat -c "%a" /etc/shadow)
if [ "$SHADOW_PERM" -eq 600 ] || [ "$SHADOW_PERM" -eq 640 ]; then
    echo "[PASS] /etc/shadow Permissions ($SHADOW_PERM)"
else
    echo "[FAIL] Insecure /etc/shadow Permissions ($SHADOW_PERM)"
fi
```

---

## Summary

Automated verification scripts validate security posture continuously and prevent compliance regression.

---

## Lab Tasks

### Task 1: Verify System Hardening and Compliance (`lnx-verify-system-hardening`)
1. Start the lab:
   ```bash
   tld start lnx-verify-system-hardening
   ```
2. Create directory `$HOME/audit-test`.
3. Write automated security verification script `$HOME/audit-test/check_compliance.sh`.
4. Write compliance verification summary `SYSTEM_HARDENING_VERIFIED: PASS` into `$HOME/audit-test/compliance.log`.
5. Validate your solution:
   ```bash
   tld check
   ```
