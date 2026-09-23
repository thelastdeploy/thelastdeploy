# Production Performance Diagnosis Capstone Challenge

In this capstone challenge, a production server experiences severe intermittent response degradation. You must apply the full performance investigation methodology: measure baseline metrics -> identify the constrained subsystem -> locate the offending process -> prove the bottleneck root cause.

---

## Troubleshooting Methodology Checklist

1. **System Load**: Check load average (`uptime`) and overall resource state.
2. **Subsystem Isolation**: Run `vmstat 1`, `mpstat -P ALL 1`, `iostat -xz 1` to isolate CPU, Memory, or Storage bottleneck.
3. **Process Attribution**: Use `pidstat -u 1` / `pidstat -d 1` / `ps aux --sort=-%cpu` to identify responsible PID.
4. **Root Cause Proof**: Document empirical metric evidence proving the bottleneck cause.

---

## Summary

Methodical performance analysis transforms vague user complaints into clear, evidence-backed diagnostic conclusions.

---

## Lab Tasks

### Task 1: Diagnose Production Performance Degradation Capstone (`lnx-diagnose-production-performance`)
1. Start the lab:
   ```bash
   tld start lnx-diagnose-production-performance
   ```
2. Create directory `$HOME/perf-challenge`.
3. Follow the 4-step performance investigation methodology to diagnose system performance degradation.
4. Write proof line `PRODUCTION_PERFORMANCE_DIAGNOSED: ROOT_CAUSE_PROVED` into `$HOME/perf-challenge/root_cause.log`.
5. Validate your solution:
   ```bash
   tld check
   ```
