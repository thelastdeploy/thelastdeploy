## Regular Expressions (Regex)

Regular expressions define search patterns for matching character combinations in text strings. In Linux, `grep -E` (or `egrep`) enables Extended Regular Expressions (ERE).

---

## 1. Core Syntax

- `.` : Matches any single character.
- `*` : Matches 0 or more occurrences of the preceding element.
- `+` : Matches 1 or more occurrences of the preceding element.
- `^` : Anchors pattern to start of line.
- `$` : Anchors pattern to end of line.
- `[0-9]` : Character class matching any single digit.
- `(foo|bar)` : Alternation (matches `foo` or `bar`).

---

## 2. Matching Patterns in Logs

### Matching IPv4 Addresses:
```bash
grep -E "([0-9]{1,3}\.){3}[0-9]{1,3}" /var/log/syslog
```

### Matching HTTP 4xx / 5xx Status Codes:
```bash
grep -E " \"(4|5)[0-9]{2} " access.log
```

---

## Lab Tasks

### Task 1: Match Log Patterns (`lnx-match-log-patterns`)
1. Start the lab:
   ```bash
   tld start lnx-match-log-patterns
   ```
2. Search `$HOME/regex-test/network.log` using `grep -E` for lines matching valid IPv4 addresses starting with `10.`.
3. Save the number of matching lines (e.g. `3`) to `$HOME/regex-test/ip_matches.txt`.
4. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Extract Patterned Data (`lnx-extract-patterned-data`)
1. Start the lab:
   ```bash
   tld start lnx-extract-patterned-data
   ```
2. Search `$HOME/regex-test/web.log` for HTTP requests containing status code `404` or `500` (e.g., matching `" (404|500) "`).
3. Save the total line count of HTTP error lines to `$HOME/regex-test/error_status_count.txt`.
4. Validate your solution:
   ```bash
   tld check
   ```
