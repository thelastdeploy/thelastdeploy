# Shell Scripting Capstone Challenge

In this final capstone challenge, you will synthesize everything you have learned throughout the Bash Shell Scripting module:

- Shebang syntax and strict execution mode (`set -euo pipefail`).
- Validating positional arguments and handling missing inputs gracefully.
- Structuring code with functions and local variables.
- Using conditional logic to evaluate system state.
- Writing formatted audit reports to target files.
- Returning precise exit codes.

## Challenge Goal

Build a production-ready system health monitoring script named `system_health.sh` in `$HOME/script-challenge/`. Your script must accept a target report path as its first argument, perform health checks, format the audit output, and handle errors cleanly.

---

## Lab Tasks

### Task 1: Build a System Health Monitoring Script (`lnx-build-system-health-script`)
1. Start the lab:
   ```bash
   tld start lnx-build-system-health-script
   ```
2. Create a comprehensive health reporting script at `$HOME/script-challenge/system_health.sh`.
3. Collect CPU, memory, and disk usage metrics and write a summary report to `$HOME/script-challenge/report.txt` containing `STATUS: HEALTHY`.
4. Validate your solution:
   ```bash
   tld check
   ```
