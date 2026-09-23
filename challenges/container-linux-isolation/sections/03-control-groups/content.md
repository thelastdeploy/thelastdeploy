# Control Groups (cgroups v1/v2) & Resource Control

While Namespaces control what a process can *see*, Control Groups (**cgroups**) govern what resources a process group can *consume* (CPU, Memory, Disk I/O, PIDs).

---

## 1. cgroups v2 Unified Hierarchy (`/sys/fs/cgroup/`)

Modern Linux distributions mount cgroups v2 at `/sys/fs/cgroup/`. Controllers are configured by writing limits into control files:

```bash
# Inspect active cgroup controllers
cat /sys/fs/cgroup/cgroup.controllers

# Create a custom cgroup subgroup
mkdir -p /sys/fs/cgroup/container_app

# Enforce 500MB memory limit
echo "524288000" > /sys/fs/cgroup/container_app/memory.max

# Enforce CPU quota (50ms execution out of 100ms period = 0.5 CPU core)
echo "50000 100000" > /sys/fs/cgroup/container_app/cpu.max

# Assign process PID to cgroup
echo "$$" > /sys/fs/cgroup/container_app/cgroup.procs
```

---

## 2. Key cgroup v2 Controllers

- **`memory.max`**: Hard memory limit (triggers Out-Of-Memory OOM killer if exceeded).
- **`memory.high`**: Throttle threshold for memory reclamation.
- **`cpu.max`**: Max CPU bandwidth quota (`$quota $period`).
- **`pids.max`**: Maximum number of tasks/threads allowed (prevents fork bombs).

---

## Summary

cgroups enforce CPU quotas, memory limits, and process count ceilings for container workloads.

---

## Lab Tasks

### Task 1: Explore cgroup Resource Control Hierarchy (`lnx-explore-cgroup-resource-control`)
1. Start the lab:
   ```bash
   tld start lnx-explore-cgroup-resource-control
   ```
2. Create directory `$HOME/cgroup-test`.
3. Inspect cgroup v2 hierarchy at `/sys/fs/cgroup/` (`memory.max`, `cpu.max`, `pids.max`).
4. Write output summary line `CGROUP_HIERARCHY_EXPLORED` to `$HOME/cgroup-test/cgroup_info.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Limit Process Resources with cgroups (`lnx-limit-process-resources`)
1. Start the lab:
   ```bash
   tld start lnx-limit-process-resources
   ```
2. Create directory `$HOME/cgroup-test`.
3. Document cgroup resource limit assignment syntax (`memory.max`, `cpu.max`, `cgroup.procs`).
4. Write output summary line `PROCESS_RESOURCES_LIMITED_VIA_CGROUP` to `$HOME/cgroup-test/limits_summary.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
