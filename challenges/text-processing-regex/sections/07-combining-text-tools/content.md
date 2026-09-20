# Combining Text Processing Tools

The true power of Linux text utilities lies in combining them into single pipelines using the pipe operator (`|`).

## 1. The Unix Pipeline Philosophy

Each tool does one job exceptionally well:
- `grep`: Filters matching lines.
- `cut`: Extracts specific columns.
- `tr`: Transforms characters.
- `sort`: Orders data.
- `uniq`: Counts and deduplicates adjacent lines.
- `awk`: Calculates totals and formats tabular data.
- `sed`: Replaces strings or modifies stream structure.

## 2. Example Multi-Stage Pipeline

Extracting top IP addresses producing HTTP 500 errors from a web log:

```bash
grep ' 500 ' access.log | cut -d ' ' -f 1 | sort | uniq -c | sort -nr | head -n 5
```

By chaining commands together, complex data extraction tasks are completed concisely without writing custom program code.
