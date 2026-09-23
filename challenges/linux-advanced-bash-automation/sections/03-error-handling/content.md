# Robust Error Handling & Signal Traps

Production shell scripts must fail predictably when unexpected errors occur, preventing partial file modifications or runaway execution. Standardizing shell error flags and configuring signal handlers (`trap`) ensures clean resource teardown during normal exits or sudden interrupts.

---

## 1. Strict Execution Mode (`set -euo pipefail`)

Always declare strict mode at the top of production scripts:

```bash
#!/bin/bash
set -euo pipefail

# -e : Exit immediately if a command exits with non-zero status
# -u : Treat unset variables as an error and exit immediately
# -o pipefail : Return status of the last command in a pipe that failed
```

---

## 2. Signal Handling with `trap`

Use `trap` to register cleanup functions for signals like `EXIT`, `SIGINT` (Ctrl+C), and `SIGTERM`:

```bash
#!/bin/bash
set -euo pipefail

TEMP_DIR=$(mktemp -d)

cleanup() {
    echo "Cleaning up temporary files in $TEMP_DIR..."
    rm -rf "$TEMP_DIR"
}

# Execute cleanup function on exit or interrupt
trap cleanup EXIT SIGINT SIGTERM
```

---

## Summary

Combining strict mode with signal traps prevents orphaned background jobs, stale lock files, and silent failures in automated pipelines.

---

## Lab Tasks

### Task 1: Build a Failure-Safe Script with strict mode (`lnx-build-failure-safe-script`)
1. Start the lab:
   ```bash
   tld start lnx-build-failure-safe-script
   ```
2. Create directory `$HOME/err-test`.
3. Create executable script `$HOME/err-test/safe_run.sh`.
4. Script requirements:
5. - Must include `set -euo pipefail`.
6. - Must check if `$1` is provided. If missing, print `Usage: safe_run.sh <file>` and exit code 2.
7. - If `$1` is provided, print `Processing $1` and exit code 0.
8. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Handle Script Traps and Signals (`lnx-handle-script-signals`)
1. Start the lab:
   ```bash
   tld start lnx-handle-script-signals
   ```
2. Create directory `$HOME/trap-test`.
3. Create executable script `$HOME/trap-test/trap_demo.sh`.
4. Script requirements:
5. - Touch lock file `$HOME/trap-test/work.lock`.
6. - Register `trap` for `EXIT SIGINT SIGTERM` that removes `$HOME/trap-test/work.lock` and appends `Cleaned up lock file` to `$HOME/trap-test/cleanup_log.txt`.
7. Execute `$HOME/trap-test/trap_demo.sh` to trigger trap completion.
8. Validate your solution:
   ```bash
   tld check
   ```
