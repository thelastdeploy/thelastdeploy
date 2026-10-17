# Production Automation Capstone Challenge

This challenge evaluates your ability to refactor legacy shell automation scripts into robust, production-grade tools. You must enforce strict execution flags, implement signal traps, construct modular shell functions, protect state with lock files, and guarantee idempotent operation.

---

## Production Automation Checklist

1. **Strict Mode**: Declare `set -euo pipefail` at script header.
2. **Signal Cleanup**: Register `trap` to release lock files and temporary state on `EXIT`.
3. **Idempotency**: Verify system state before applying mutations to avoid state corruption.
4. **Concurrency Protection**: Use lock files or atomic swaps to prevent race conditions.
5. **Structured Logging**: Output formatted logs with timestamps and status indicators.

---

## Lab Tasks

### Task 1: Build Production Automation Tool Capstone (`lnx-build-production-automation`)
1. Start the lab:
   ```bash
   tld start lnx-build-production-automation
   ```
2. Create directory `$HOME/bash-challenge`:
   ```bash
   mkdir -p ~/bash-challenge
   ```
3. Create the production automation script `$HOME/bash-challenge/production_tool.sh`:
   ```bash
   cat << 'EOF' > ~/bash-challenge/production_tool.sh
   #!/bin/bash
   set -euo pipefail

   LOCK="$HOME/bash-challenge/temp.lock"
   STATUS="$HOME/bash-challenge/status.log"
   ENV_FILE="$HOME/bash-challenge/app.env"

   cleanup() {
       rm -f "$LOCK"
   }
   trap cleanup EXIT

   touch "$LOCK"

   log_info() {
       echo "[INFO] $1"
   }

   log_error() {
       echo "[ERROR] $1" >&2
   }

   log_info "Initializing production tool"

   # Idempotent write to app.env
   cat << 'ENVEOF' > "$ENV_FILE"
   ENV=production
   VERSION=2.0
   ENVEOF

   echo "PRODUCTION_AUTOMATION_COMPLETE" >> "$STATUS"
   log_info "Production automation completed successfully"
   EOF
   chmod +x ~/bash-challenge/production_tool.sh
   ```
4. Execute `production_tool.sh`:
   ```bash
   ~/bash-challenge/production_tool.sh
   cat ~/bash-challenge/status.log
   cat ~/bash-challenge/app.env
   ```
5. Validate your solution:
   ```bash
   tld check
   ```

