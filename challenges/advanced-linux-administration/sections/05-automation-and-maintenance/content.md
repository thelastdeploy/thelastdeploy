# Automation & Maintenance Workflows

Automating routine system administration: cron schedules, systemd timers, automated backup scripts, and log rotation policies.

Manual administration is prone to human error and inconsistency. Senior administrators automate recurring operations—such as log rotation, security patch updates, system back-ups, and integrity checking—using shell scripts and systemd timer units.

### Systemd Timers vs Cron
- **Systemd Timers**: Support precise execution timing, log aggregation via journalctl, resource control, and execution dependencies.
- **Backup Verification**: Automated script must verify backup archive hash integrity and generate alert logs upon failure.


---

## Lab Tasks

### Task 1: Automate Administration Tasks (`lnx-automate-administration-tasks`)
1. Start the lab:
   ```bash
   tld start lnx-automate-administration-tasks
   ```
2. Create directory `$HOME/admin-auto`.
3. Write an automated system administration script `automation_tasks.sh` that checks disk usage and rotates old log archives.
4. Include log header `ADMINISTRATION_TASKS_AUTOMATED` inside `$HOME/admin-auto/automation_tasks.sh`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Build Maintenance Workflow (`lnx-build-maintenance-workflow`)
1. Start the lab:
   ```bash
   tld start lnx-build-maintenance-workflow
   ```
2. Configure a systemd timer unit (`.timer` + `.service`) to run routine maintenance jobs automatically.
3. Implement archive checksum hash verification.
4. Write `SYSTEMD_TIMER_MAINTENANCE_WORKFLOW_ACTIVE` into `$HOME/admin-auto/maintenance_workflow.status`.
5. Validate your solution:
   ```bash
   tld check
   ```
