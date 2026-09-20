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
