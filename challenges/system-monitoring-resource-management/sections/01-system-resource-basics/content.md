# Section 01 — System Resource Basics

Monitoring Linux system performance requires tracking four fundamental hardware resource metrics: CPU, RAM, disk I/O, and system load.

## Fundamental Inspection Utilities

- `top` / `htop`: Interactive real-time process viewer and system resource monitor.
- `uptime`: Display server uptime, active user sessions, and 1, 5, and 15-minute load averages.
- `free -h`: Summarize total, used, free, shared, buffer/cache, and available RAM in human-readable units.
- `vmstat 1 5`: Report virtual memory statistics, CPU utilization (user, system, idle, wait), and swap activity sampled every second.

## Identifying Resource Pressure

Resource pressure occurs when hardware demand exceeds capacity. Early indicators include elevated iowait (`wa`), high memory swap-in/out rate (`si`/`so`), or sustained load averages exceeding available CPU core counts.
