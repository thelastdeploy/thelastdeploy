# Advanced Modular Shell Functions

Modular function design converts monolithic shell scripts into testable, maintainable libraries. By scoping variables locally and returning explicit status codes, functions can be safely sourced across multiple automation entry points.

---

## 1. Function Scope & Local Variables

Always declare function variables as `local` to avoid polluting the global shell scope:

```bash
log_message() {
    local level="$1"
    local msg="$2"
    local timestamp
    timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] [$level] $msg"
}
```

---

## 2. Return Codes & Library Sourcing

Functions return integer status codes (`0-255`) via `return`:

```bash
is_service_active() {
    local svc="$1"
    systemctl is-active --quiet "$svc"
    return $?
}

# Sourcing library in another script
source /path/to/utils.sh
```

---

## Summary

Local variable scoping and explicit return status checks prevent unintended variable collisions in shared script libraries.

---

## Lab Tasks

### Task 1: Build a Reusable Shell Library (`lnx-build-reusable-shell-library`)
1. Start the lab:
   ```bash
   tld start lnx-build-reusable-shell-library
   ```
2. Create directory `$HOME/lib-test`.
3. Create reusable shell library `$HOME/lib-test/utils.sh` with:
4. - `log_info`: prints `[INFO] <message>`
5. - `log_error`: prints `[ERROR] <message>` to stderr
6. - `is_file_empty`: accepts filename `$1`, returns 0 if file is empty or does not exist, returns 1 if file has size > 0.
7. Create `$HOME/lib-test/test_runner.sh` sourcing `utils.sh` and exercising these functions.
8. Validate your solution:
   ```bash
   tld check
   ```
