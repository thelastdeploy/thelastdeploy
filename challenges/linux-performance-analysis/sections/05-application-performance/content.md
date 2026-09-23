# Application Latency & System Correlation

Application slowness reported by end users must be correlated against underlying system resource constraints to prove whether latency stems from CPU exhaustion, memory paging, disk I/O wait, or network backlog.

---

## 1. Symptom to Resource Matrix

| Reported Application Symptom | System Metric Evidence | Subsystem Root Cause |
| :--- | :--- | :--- |
| High HTTP request latency, slow response times | High `%iowait` in `mpstat`, high `await` in `iostat` | Storage I/O bottleneck (disk queuing) |
| Intermittent application freeze / spike | Non-zero `si`/`so` in `vmstat`, high swap usage | Memory pressure & swap thrashing |
| High CPU usage, slow request processing | High `r` queue in `vmstat`, 100% `%usr` in `mpstat` | CPU saturation |
| Connection timeouts under load | TCP listen backlog drops (`netstat -s` or `ss -l`) | Socket backlog / network queue overflow |

---

## 2. Multi-Metric Correlation

Correlate process PIDs across tools (`ps`, `pidstat`, `iostat`, `vmstat`) to build empirical proof of the root cause before applying changes.

---

## Summary

Correlating application response metrics with system resource counters provides empirical proof of root cause.

---

## Lab Tasks

### Task 1: Investigate Slow Application Response (`lnx-investigate-slow-application`)
1. Start the lab:
   ```bash
   tld start lnx-investigate-slow-application
   ```
2. Create directory `$HOME/app-perf-test`.
3. Correlate application response latency against system metrics.
4. Write summary output `APPLICATION_LATENCY_INVESTIGATED` into `$HOME/app-perf-test/app_latency.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Correlate System Performance Metrics (`lnx-correlate-system-performance`)
1. Start the lab:
   ```bash
   tld start lnx-correlate-system-performance
   ```
2. Create directory `$HOME/app-perf-test`.
3. Correlate multi-subsystem metrics (CPU, Memory, Disk I/O).
4. Write output summary line `METRICS_CORRELATED: SYSTEM_HEALTHY` into `$HOME/app-perf-test/correlation_report.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
