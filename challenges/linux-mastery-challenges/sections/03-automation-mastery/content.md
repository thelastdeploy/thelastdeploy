# Automation Mastery

Demonstrate mastery of production Bash automation scripts, error handling (`set -euo pipefail`), cron schedules, and systemd timer units.

Automation mastery tests your ability to write resilient, idempotent Linux administration scripts and scheduled jobs.

### Automation Standards
- **Defensive Bash**: Trap handlers, exit status validation, atomic file operations, lockfiles (`flock`).
- **Scheduling**: Systemd timer units (`OnCalendar=`, `Persistent=true`) for enterprise background processing.


---

## Lab Tasks

### Task 1: Automate Linux Operations (`lnx-automate-linux-operations`)
1. Start the lab:
   ```bash
   tld start lnx-automate-linux-operations
   ```
2. Create directory `$HOME/mastery-auto`.
3. Author `automation_mastery.sh` with robust error trapping and systemd timer activation.
4. Write header `PRODUCTION_LINUX_AUTOMATION_MASTERED` into `$HOME/mastery-auto/automation_mastery.sh`.
5. Validate your solution:
   ```bash
   tld check
   ```
