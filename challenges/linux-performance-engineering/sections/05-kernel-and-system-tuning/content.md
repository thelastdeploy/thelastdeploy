# Kernel sysctl & Network Stack Tuning

High-throughput server workloads require tuning kernel network stack buffer limits, TCP socket keepalive parameters, and maximum file descriptor limits to handle massive concurrent socket connections without packet drops or socket starvation.

---

## 1. High-Performance Network Stack sysctl Configuration

Create persistent sysctl configuration `/etc/sysctl.d/99-network-performance.conf`:

```ini
# Maximum socket listen backlog queue size
net.core.somaxconn = 65535

# Maximum socket receive/send buffer sizes (16MB)
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216

# Minimum, default, and maximum TCP buffer sizes
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 65536 16777216

# Enable TCP BBR congestion control algorithm (if supported)
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr

# Reuse TIME_WAIT sockets for outgoing connections
net.ipv4.tcp_tw_reuse = 1
```

---

## 2. System Resource Limits (`/etc/security/limits.conf`)

Ensure high-concurrency processes do not hit open file handle (`nofile`) ceilings:

```text
*    soft    nofile    1048576
*    hard    nofile    1048576
```

---

## Summary

Tuning `net.core.somaxconn`, TCP buffer sizes, and open file limits (`nofile`) enables high-throughput socket execution.

---

## Lab Tasks

### Task 1: Analyze Kernel Subsystem Tuneables (`lnx-analyze-kernel-performance`)
1. Start the lab:
   ```bash
   tld start lnx-analyze-kernel-performance
   ```
2. Create directory `$HOME/kernel-opt-test`.
3. Inspect kernel network stack tuneables (`net.core.somaxconn`, TCP window sizing, file descriptor limits).
4. Write output summary line `KERNEL_TUNEABLES_ANALYZED` to `$HOME/kernel-opt-test/sysctl_analysis.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Tune System Performance Parameters (`lnx-tune-system-performance`)
1. Start the lab:
   ```bash
   tld start lnx-tune-system-performance
   ```
2. Create directory `$HOME/kernel-opt-test`.
3. Apply persistent sysctl tuning rules for high-throughput server workloads.
4. Write configuration summary line `SYSTEM_PERFORMANCE_TUNED` to `$HOME/kernel-opt-test/system_tuned.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
