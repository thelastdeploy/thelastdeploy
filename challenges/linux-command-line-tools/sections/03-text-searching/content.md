## Text Searching with grep

`grep` (Global Regular Expression Print) searches named input files for lines matching a target pattern.

---

## 1. Key Options

- `-i`: Case-insensitive search.
- `-v`: Invert match (returns lines that do **not** match the pattern).
- `-c`: Output only a count of matching lines.
- `-n`: Prefix output lines with 1-based line numbers.
- `-r` / `-R`: Recursively search directories.

---

## 2. Searching Context (`-A`, `-B`, `-C`)

When investigating application crashes, viewing lines directly surrounding an error pattern reveals root cause details:
- `-B N`: Print $N$ lines **Before** matching lines.
- `-A N`: Print $N$ lines **After** matching lines.
- `-C N`: Print $N$ lines of **Context** (both before and after).

```bash
grep -C 2 -i "fatal" /var/log/app.log
```

---

## Lab Tasks

### Task 1: Search Application Logs (`lnx-search-application-logs`)
1. Start the lab:
   ```bash
   tld start lnx-search-application-logs
   ```
2. Search `$HOME/grep-test/app.log` for lines containing `CRITICAL`.
3. Save the number of matching lines to `$HOME/grep-test/critical_count.txt`.
4. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Investigate Log Patterns (`lnx-investigate-log-patterns`)
1. Start the lab:
   ```bash
   tld start lnx-investigate-log-patterns
   ```
2. Search `$HOME/grep-test/service.log` for the line containing `SIGSEGV`.
3. Extract the line immediately following `SIGSEGV` (using `grep -A 1`) and save it to `$HOME/grep-test/next_line.txt`.
4. Validate your solution:
   ```bash
   tld check
   ```
