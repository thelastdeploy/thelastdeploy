# Section 02 — CPU & Processes

CPU usage represents processor cycles executing instructions. Linux categorizes CPU usage into user space (`us`), kernel system space (`sy`), nice priorities (`ni`), idle time (`id`), and iowait (`wa`).

## Process CPU Inspection Commands

- `ps aux --sort=-%cpu | head -n 10`: List top 10 CPU-consuming processes.
- `top -b -n 1 -o %CPU`: Batch mode snapshot of process table sorted by CPU utilization.
- `pidstat -u 1 5`: Per-process CPU utilization breakdown every second.

## User vs System Time

- **High User Time (`us`)**: Indicates application compute workloads (e.g., encryption, compression, infinite loops).
- **High System Time (`sy`)**: Indicates excessive kernel context switching or system call overhead.
