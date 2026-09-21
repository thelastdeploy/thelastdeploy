# Section 06 — Resource Investigation

Complex performance incidents rarely stem from a single isolated metric. Effective troubleshooting requires correlating signals across CPU, RAM, disk I/O, and kernel event logs.

## Metric Correlation Matrix

1. **High CPU + Low I/O**: Compute-bound workload or infinite loop.
2. **High Load + Low CPU % + High `wa`**: Disk I/O bottleneck or failing disk device.
3. **High Swap-Out (`so`) + High `si` + OOM messages**: Physical RAM exhaustion leading to thrashing.
4. **High Network Drop Rates + High CPU System Time (`sy`)**: Network interface packet ring buffer exhaustion or interrupt flooding.
