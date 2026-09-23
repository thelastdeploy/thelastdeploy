# Production System Administration

Auditing inherited Linux production systems, documenting operational baselines, evaluating configuration drift, and establishing governance standards.

Senior Linux system administration begins with thorough system discovery and baseline auditing. When taking over an unfamiliar production environment, a systematic audit covers hardware specifications, OS release, running services, network listeners, user privileges, and storage topologies.

### Baseline Audit Framework
1. **Host & OS Governance**: `/etc/os-release`, `uname -r`, system uptime.
2. **Account Audit**: Active `/etc/passwd`, `/etc/sudoers.d/`, SSH authorization keys.
3. **Listening Services & Firewall**: `ss -tulpn`, `nftables`/`iptables` rules.
4. **Storage & Mounts**: `lsblk`, `df -h`, `/etc/fstab` configuration.


---

## Lab Tasks

### Task 1: Audit Production System (`lnx-audit-production-system`)
1. Start the lab:
   ```bash
   tld start lnx-audit-production-system
   ```
2. Create directory `$HOME/sysadmin-audit`.
3. Audit OS version, running services, listening ports, user accounts, and mounted filesystems.
4. Write `PRODUCTION_SERVER_AUDIT_COMPLETED` into `$HOME/sysadmin-audit/system_inventory.log`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Establish Administration Baseline (`lnx-establish-administration-baseline`)
1. Start the lab:
   ```bash
   tld start lnx-establish-administration-baseline
   ```
2. Establish CPU, memory, network, and storage performance baseline thresholds.
3. Define standard sysctl tuning parameters and security defaults.
4. Write `OPERATIONAL_ADMINISTRATION_BASELINE_ESTABLISHED` into `$HOME/sysadmin-audit/admin_baseline.conf`.
5. Validate your solution:
   ```bash
   tld check
   ```
