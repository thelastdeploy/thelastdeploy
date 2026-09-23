# Security Mastery

Demonstrate mastery of Linux security baselines: SSH daemon hardening, stateful firewall policies, PAM authentication rules, and filesystem auditing.

Security mastery evaluates your ability to harden production systems against unauthorized access and privilege escalation.

### Security Frameworks
- **Access Control**: Sudoers privilege restriction, disabling password SSH logins, SSH key enforcement.
- **Perimeter & Audit**: Stateful firewall policy (`nftables`/`iptables`), auditd security event rules.


---

## Lab Tasks

### Task 1: Secure Linux Production System (`lnx-secure-linux-production-system`)
1. Start the lab:
   ```bash
   tld start lnx-secure-linux-production-system
   ```
2. Create directory `$HOME/mastery-sec`.
3. Harden SSH config, configure stateful firewall rules, and restrict sudo privileges.
4. Write `PRODUCTION_SYSTEM_SECURITY_MASTERED` into `$HOME/mastery-sec/security_mastery.conf`.
5. Validate your solution:
   ```bash
   tld check
   ```
