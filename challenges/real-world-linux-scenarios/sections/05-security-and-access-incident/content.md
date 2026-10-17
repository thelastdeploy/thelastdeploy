# Security & Compromise Incident Scenarios

Investigate, isolate, and contain compromised server processes, unauthorized persistence mechanisms, and rogue crypto miner executions.

Security incidents require rapid containment without destroying diagnostic evidence. When an unauthorized process or compromise occurs, system administrators must isolate the environment, terminate unauthorized execution paths, clean persistence hooks (`/etc/cron.*`, `/etc/systemd/system/`), and restore service integrity.

### Incident Containment
- **Identify Rogue Execution**: `/proc/[pid]/exe`, `ls -l /proc/[pid]/cwd`.
- **Remove Persistence**: Check cron directories, systemd timers, `.bashrc` hooks.

---

## Lab Tasks

### Task 1: Recover Compromised Service (`lnx-recover-compromised-service`)
1. Start the lab session:
   ```bash
   tld start lnx-recover-compromised-service
   ```
2. Create the destination directory for security incident containment logs:
   ```bash
   mkdir -p "$HOME/security-incident"
   ```
3. Locate rogue process binary paths via `/proc/[pid]/exe` and identify unauthorized process trees.
4. Terminate rogue processes, delete persistent cron/systemd entries, and harden file permissions.
5. Record the containment verification marker into `$HOME/security-incident/incident_containment.log`:
   ```bash
   echo "COMPROMISED_SERVICE_CONTAINED_AND_RECOVERED" > "$HOME/security-incident/incident_containment.log"
   ```
6. Verify file contents:
   ```bash
   cat "$HOME/security-incident/incident_containment.log"
   ```
7. Validate your solution:
   ```bash
   tld check
   ```
