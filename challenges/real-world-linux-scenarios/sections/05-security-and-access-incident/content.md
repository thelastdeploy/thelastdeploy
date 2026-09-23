# Security & Compromise Incident Scenarios

Investigate, isolate, and contain compromised server processes, unauthorized persistence mechanisms, and rogue crypto miner executions.

Security incidents require rapid containment without destroying diagnostic evidence. When an unauthorized process or compromise occurs, system administrators must isolate the environment, terminate unauthorized execution paths, clean persistence hooks (`/etc/cron.*`, `/etc/systemd/system/`), and restore service integrity.

### Incident Containment
- **Identify Rogue Execution**: `/proc/[pid]/exe`, `ls -l /proc/[pid]/cwd`.
- **Remove Persistence**: Check cron directories, systemd timers, `.bashrc` hooks.


---

## Lab Tasks

### Task 1: Recover Compromised Service (`lnx-recover-compromised-service`)
1. Start the lab:
   ```bash
   tld start lnx-recover-compromised-service
   ```
2. Create directory `$HOME/security-incident`.
3. Locate rogue process binary path via `/proc/[pid]/exe`.
4. Terminate rogue process, delete persistent cron/systemd entry, and harden permissions.
5. Write `COMPROMISED_SERVICE_CONTAINED_AND_RECOVERED` into `$HOME/security-incident/incident_containment.log`.
6. Validate your solution:
   ```bash
   tld check
   ```
