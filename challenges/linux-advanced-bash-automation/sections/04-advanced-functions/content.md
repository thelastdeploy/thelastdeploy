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
2. Create directory `$HOME/lib-test`:
   ```bash
   mkdir -p ~/lib-test
   ```
3. Create the reusable shell library `$HOME/lib-test/utils.sh`:
   ```bash
   cat << 'EOF' > ~/lib-test/utils.sh
   #!/bin/bash

   log_info() {
       echo "[INFO] $1"
   }

   log_error() {
       echo "[ERROR] $1" >&2
   }

   is_file_empty() {
       local file="${1:-}"
       if [ ! -f "$file" ] || [ ! -s "$file" ]; then
           return 0
       else
           return 1
       fi
   }
   EOF
   chmod +x ~/lib-test/utils.sh
   ```
4. Create `$HOME/lib-test/test_runner.sh` to test the library:
   ```bash
   cat << 'EOF' > ~/lib-test/test_runner.sh
   #!/bin/bash
   source "$HOME/lib-test/utils.sh"

   log_info "Running test suite"
   EOF
   chmod +x ~/lib-test/test_runner.sh
   ~/lib-test/test_runner.sh
   ```
5. Validate your solution:
   ```bash
   tld check
   ```

