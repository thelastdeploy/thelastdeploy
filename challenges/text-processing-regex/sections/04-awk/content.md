# AWK Data Processing

`awk` is a powerful text processing language designed for extracting fields, scanning data patterns, and generating reports.

## 1. Core AWK Syntax

`awk` operates line by line:
```bash
awk 'pattern { action }' file
```

## 2. Field Variables and Built-in Variables

- `$0`: The entire line.
- `$1`, `$2`, `$3`: The 1st, 2nd, and 3rd whitespace-delimited fields.
- `NF`: Number of Fields on the current line.
- `NR`: Number of Records (current line number).

Example:
```bash
# Print line number and the 2nd field
awk '{ print NR, $2 }' data.txt

# Specify custom field separator (e.g. colon)
awk -F ':' '{ print $1, $3 }' /etc/passwd
```

## 3. Conditionals and Aggregation (`BEGIN` and `END`)

Execute initialization code before processing lines with `BEGIN`, and print totals after processing all lines with `END`:

```bash
awk 'BEGIN { sum=0 } { sum += $2 } END { print "Total:", sum }' numbers.txt
```
