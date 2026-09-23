# Userspace Initialization & Boot Ordering

Once the Linux kernel mounts the real root filesystem and executes `systemd` as PID 1, `systemd` initializes userspace services in parallel according to unit dependency graphs (`Wants=`, `Requires=`, `After=`, `Before=`).

---

## 1. Analyzing Boot Performance (`systemd-analyze`)

`systemd-analyze` provides detailed timing measurements for kernel and userspace boot duration:

```bash
# View high-level boot time duration summary
systemd-analyze

# List units sorted by time taken to initialize during boot
systemd-analyze blame

# View critical chain dependency bottleneck paths
systemd-analyze critical-chain
```

---

## 2. Boot Target Transition Flow

```text
sysinit.target -> basic.target -> multi-user.target -> graphical.target
```

Each target activates specific system services (networking, logging, storage mounts) before reaching the default target.

---

## Summary

`systemd-analyze` pinpoints startup bottlenecks along the boot critical chain.

---

## Lab Tasks

### Task 1: Analyze Boot Service Startup Order (`lnx-analyze-boot-service-order`)
1. Start the lab:
   ```bash
   tld start lnx-analyze-boot-service-order
   ```
2. Create directory `$HOME/sys-init-test`.
3. Run `systemd-analyze critical-chain` to inspect critical boot ordering path.
4. Write summary `CRITICAL_CHAIN_INSPECTED` to `$HOME/sys-init-test/critical_chain.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Trace Userspace Initialization Sequence (`lnx-trace-userspace-initialization`)
1. Start the lab:
   ```bash
   tld start lnx-trace-userspace-initialization
   ```
2. Create directory `$HOME/sys-init-test`.
3. Run `systemd-analyze` to measure boot performance.
4. Write output summary line `BOOT_TIME_ANALYZED` to `$HOME/sys-init-test/boot_time.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
