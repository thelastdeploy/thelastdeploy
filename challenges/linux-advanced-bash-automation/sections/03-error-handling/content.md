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
2. Create directory `$HOME/err-test`:
   ```bash
   mkdir -p ~/err-test
   ```
3. Create the script `$HOME/err-test/safe_run.sh`:
   ```bash
   cat << 'EOF' > ~/err-test/safe_run.sh
   #!/bin/bash
   set -euo pipefail

   if [ $# -lt 1 ] || [ -z "${1:-}" ]; then
       echo "Usage: safe_run.sh <file>"
       exit 2
   fi

   echo "Processing $1"
   exit 0
   EOF
   chmod +x ~/err-test/safe_run.sh
   ```
4. Test running the script with an argument:
   ```bash
   ~/err-test/safe_run.sh myfile.txt
   ```
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Handle Script Traps and Signals (`lnx-handle-script-signals`)
1. Start the lab:
   ```bash
   tld start lnx-handle-script-signals
   ```
2. Create directory `$HOME/trap-test`:
   ```bash
   mkdir -p ~/trap-test
   ```
3. Create the script `$HOME/trap-test/trap_demo.sh`:
   ```bash
   cat << 'EOF' > ~/trap-test/trap_demo.sh
   #!/bin/bash
   set -euo pipefail

   LOCK="$HOME/trap-test/work.lock"
   LOG="$HOME/trap-test/cleanup_log.txt"

   cleanup() {
       rm -f "$LOCK"
       echo "Cleaned up lock file" >> "$LOG"
   }

   trap cleanup EXIT SIGINT SIGTERM

   touch "$LOCK"
   echo "Working..."
   EOF
   chmod +x ~/trap-test/trap_demo.sh
   ```
4. Execute `$HOME/trap-test/trap_demo.sh` to trigger trap completion:
   ```bash
   ~/trap-test/trap_demo.sh
   cat ~/trap-test/cleanup_log.txt
   ```
5. Validate your solution:
   ```bash
   tld check
   ```

