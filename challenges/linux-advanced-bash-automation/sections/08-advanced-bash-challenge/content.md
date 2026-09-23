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
2. Create directory `$HOME/bash-challenge/`.
3. Write executable script `$HOME/bash-challenge/production_tool.sh` that implements all robust production practices:
4. - Set `set -euo pipefail`.
5. - Acquire lock file `$HOME/bash-challenge/temp.lock` and set `trap` on `EXIT` to remove `$HOME/bash-challenge/temp.lock`.
6. - Define helper functions `log_info` and `log_error`.
7. - Ensure idempotent file creation of `$HOME/bash-challenge/app.env` with `ENV=production` and `VERSION=2.0`.
8. - Write line `PRODUCTION_AUTOMATION_COMPLETE` to `$HOME/bash-challenge/status.log`.
9. Execute `$HOME/bash-challenge/production_tool.sh`.
10. Validate your solution:
   ```bash
   tld check
   ```
