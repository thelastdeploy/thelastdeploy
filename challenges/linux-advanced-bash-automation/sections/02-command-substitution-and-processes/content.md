# Command Substitution & Process Flow

Automation scripts rely heavily on capturing execution results and chaining command streams. Understanding process substitution, subshells, and word-splitting prevention ensures that output processing remains deterministic and immune to syntax errors caused by spaces or line breaks.

---

## 1. Safe Command Substitution

Always use `$()` syntax instead of legacy backticks `` `command` ``:

```bash
# Correct syntax
KERNEL_VERSION=$(uname -r)
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Always quote command substitution variables to prevent word splitting
FILE_LIST="$(ls -1 /var/log/*.log 2>/dev/null)"
```

---

## 2. Process Substitution

Process substitution allows the output of a command to appear as a temporary file descriptor (`/dev/fd/N`), enabling commands that require file path arguments to read directly from subshell streams:

```bash
# Compare output of two command streams without temporary files
diff -u <(sort listA.txt) <(sort listB.txt)

# Read command output line-by-line while keeping variable mutations in main shell
while IFS= read -r line; do
    echo "Line: $line"
done < <(grep "ERROR" /var/log/syslog)
```

---

## Summary

Process substitution `<(...)` avoids subshell scope isolation issues caused by piping into `while` loops (`cmd | while read`), preserving variable state across iterations.

---

## Lab Tasks

### Task 1: Compose Command Output in Scripts (`lnx-compose-command-output`)
1. Start the lab:
   ```bash
   tld start lnx-compose-command-output
   ```
2. Create directory `$HOME/sub-test`.
3. Write a script or bash commands that capture system details into `$HOME/sub-test/system_info.txt`:
4. - `ARCH: <uname -m>`
5. - `USER: <whoami>`
6. - `DATE: <date +%Y-%m-%d>`
7. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Manage Advanced Process Substitution (`lnx-manage-command-substitution`)
1. Start the lab:
   ```bash
   tld start lnx-manage-command-substitution
   ```
2. Create directory `$HOME/proc-sub-test`.
3. Seed two files:
4. - `old_list.txt` containing `nginx`, `redis`, `mysql`
5. - `new_list.txt` containing `nginx`, `redis`, `postgresql`
6. Use process substitution with `comm` or `grep` to compare sorted inputs without intermediate temporary files, and write the newly added service (`postgresql`) into `$HOME/proc-sub-test/diff_report.txt`.
7. Validate your solution:
   ```bash
   tld check
   ```
