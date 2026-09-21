# Sorting and Counting

Analyzing log frequency and ordering dataset lines require the `sort` and `uniq` utilities.

## 1. Sorting Streams with `sort`

The `sort` command rearranges lines of text files.

Common flags:
- `-n`: Sort numerically rather than alphabetically.
- `-r`: Reverse the result of comparisons (descending order).
- `-u`: Output only unique lines.

```bash
# Sort log entries numerically in descending order
sort -nr data.txt
```

## 2. Counting Duplicates with `uniq`

The `uniq` tool removes adjacent duplicate lines from standard input. *Note: `uniq` requires sorted input to identify all duplicates.*

Common flags:
- `-c`: Prefix lines by the number of occurrences.
- `-d`: Only print duplicate lines.
- `-u`: Only print unique lines (lines that appear exactly once).

## 3. The Classic Frequency Pipeline

To count unique items and rank them from most frequent to least frequent:

```bash
sort input.txt | uniq -c | sort -nr > counts.txt
```

---

## Lab Tasks

### Task 1: Analyze Repeated Data with Sort and Uniq (`lnx-analyze-repeated-data`)
1. Start the lab:
   ```bash
   tld start lnx-analyze-repeated-data
   ```
2. Analyze duplicate lines using `sort` and `uniq`.
3. Count unique IP addresses in `$HOME/text-test/access.log` and save sorted count results to `$HOME/text-test/unique_ips.txt`.
4. Validate your solution:
   ```bash
   tld check
   ```
