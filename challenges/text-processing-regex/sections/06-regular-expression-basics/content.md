# Regular Expression Basics

Regular Expressions (Regex) provide pattern-matching logic to find, parse, and replace complex string formats in log files and text streams.

## 1. Line Anchors and Basic Operators

- `^`: Matches the start of a line.
- `$`: Matches the end of a line.
- `.`: Matches any single character.
- `*`: Matches 0 or more occurrences of the preceding character/group.

```bash
# Match lines starting with ERROR
grep '^ERROR' server.log

# Match empty lines
grep '^$' file.txt
```

## 2. Character Classes and Quantifiers (`grep -E`)

Enable Extended Regular Expressions (ERE) using `grep -E` (or `egrep`):

- `[0-9]`: Any digit character.
- `[a-zA-Z]`: Any uppercase or lowercase letter.
- `+`: Matches 1 or more occurrences.
- `?`: Matches 0 or 1 occurrence.
- `|`: Alternation operator (OR condition).

```bash
# Match IP address structures
grep -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' network.log

# Match ERROR or WARN keywords
grep -E 'ERROR|WARN' app.log
```

---

## Lab Tasks

### Task 1: Match Text Patterns with Grep Anchors (`lnx-match-text-patterns`)
1. Start the lab:
   ```bash
   tld start lnx-match-text-patterns
   ```
2. Match text line anchors using basic regex with `grep`.
3. Extract lines starting with `ERROR` from `$HOME/text-test/app.log` and write to `$HOME/text-test/anchored_errors.log`.
4. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Search Structured Patterns using Extended Regex (`lnx-search-structured-patterns`)
1. Start the lab:
   ```bash
   tld start lnx-search-structured-patterns
   ```
2. Search complex patterns using extended regular expressions (`grep -E`).
3. Extract valid IPv4 addresses from `$HOME/text-test/network.log` and write to `$HOME/text-test/valid_ips.txt`.
4. Validate your solution:
   ```bash
   tld check
   ```
