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
