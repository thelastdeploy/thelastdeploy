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
2. Create an executable script at `$HOME/script-challenge/system_health.sh` starting with shebang `#!/bin/bash` and strict options `set -euo pipefail`.
3. The script must accept a target report path as argument `$1`. If the argument is missing, exit with code `1`.
4. When provided with a report path, write a summary report containing:
   - Header: `=== SYSTEM HEALTH REPORT ===`
   - Disk check: `DISK_STATUS: OK`
   - Overall status: `SYSTEM_STATUS: HEALTHY`
5. Validate your solution:
   ```bash
   tld check
   ```
