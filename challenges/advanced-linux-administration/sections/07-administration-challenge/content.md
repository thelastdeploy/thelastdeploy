# Production Server Takeover & Operations Capstone

Take over an unmaintained, vulnerable, unmonitored production Linux server and operationalize it to enterprise standards.

In this 125 XP Expert capstone challenge, you inherit an unmaintained Linux server running a legacy application stack. The server has multiple operational risks:
- Unhardened user access and SSH password logins enabled.
- Storage volumes running out of disk space without LVM monitoring.
- Unstructured systemd services missing restart policies and dependency ordering.
- No automated backup or maintenance timers configured.
- No operational monitoring or health alerts.

### Operationalization Checklist
1. **Audit & Baseline**: Perform full system inventory.
2. **Harden Security**: Disable SSH root/password login, enforce stateful firewall rules.
3. **Service Stack**: Re-architect systemd units with proper dependencies and restart policies.
4. **Storage Expansion**: Perform online LVM logical volume expansion.
5. **Automation & Reliability**: Deploy systemd maintenance timer and watchdog health check.
6. **Master Signoff**: Generate operationalization report.


---

## Lab Tasks

### Task 1: Operate Production Linux Server Capstone (`lnx-operate-production-linux-server`)
1. Start the lab:
   ```bash
   tld start lnx-operate-production-linux-server
   ```
2. Create directory `$HOME/server-ops`.
3. Execute complete operational overhaul: security hardening, LVM storage expansion, systemd service stack architecture, automated systemd maintenance timer, and health check monitoring.
4. Write `PRODUCTION_SERVER_OPERATIONALIZED_AND_SECURED` into `$HOME/server-ops/operationalization_signoff.log`.
5. Validate your solution:
   ```bash
   tld check
   ```
