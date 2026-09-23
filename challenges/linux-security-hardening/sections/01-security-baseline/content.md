# Security Baseline & Vulnerability Auditing

A security baseline defines the minimal acceptable security configuration for an operating system. Conducting security audits ensures that system parameters, kernel flags, file permissions, and active network services comply with organizational security standards (such as CIS Benchmarks).

---

## 1. Core Security Audit Areas

A thorough Linux security baseline audit covers five key system domains:

1. **User & Authentication Controls**: Password age policies (`/etc/login.defs`), empty passwords (`/etc/shadow`), and root account lock status.
2. **Filesystem Permissions**: World-writable files, unowned files, and unauthorized SUID/SGID binaries.
3. **Network Services**: Exposed listening ports (`ss -tulpn`) and active firewall rules (`iptables` / `nft`).
4. **Kernel Hardening**: Sysctl security parameters (`/etc/sysctl.d/`) including ASLR, SYN cookies, and IP forwarding restrictions.
5. **Logging & Auditing**: System audit daemon status (`auditd`) and centralized log retention.

---

## 2. Auditing Tools & Commands

```bash
# Check kernel security parameters
sysctl net.ipv4.tcp_syncookies net.ipv4.ip_forward

# Find world-writable files (excluding proc/sys pseudofs)
find / -maxdepth 3 -type f -perm -0002 2>/dev/null

# List users with empty password fields in /etc/shadow
awk -F: '($2 == "") { print $1 }' /etc/shadow
```

---

## Summary

Regular baseline auditing detects configuration drift, unauthorized permission changes, and exposed network services before exploitation occurs.

---

## Lab Tasks

### Task 1: Audit System Security Baseline (`lnx-audit-system-security-baseline`)
1. Start the lab:
   ```bash
   tld start lnx-audit-system-security-baseline
   ```
2. Create directory `$HOME/sec-test`.
3. Perform system security baseline inspection.
4. Write output summary line `SECURITY_BASELINE_AUDITED` to `$HOME/sec-test/baseline_report.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Identify System Security Weaknesses (`lnx-identify-security-weaknesses`)
1. Start the lab:
   ```bash
   tld start lnx-identify-security-weaknesses
   ```
2. Create directory `$HOME/sec-test`.
3. Identify security weaknesses (unsecured permissions, open ports, weak credentials).
4. Write output line `WEAKNESSES_IDENTIFIED` into `$HOME/sec-test/weaknesses.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
