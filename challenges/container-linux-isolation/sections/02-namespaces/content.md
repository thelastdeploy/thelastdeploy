# Linux Namespaces (PID, NET, MNT, IPC, UTS, USER)

Linux Namespaces wrap system resources into isolated abstractions. A process operating inside a namespace sees only the resources associated with that specific namespace instance.

---

## 1. The 7 Primary Linux Namespace Types

| Namespace | Constant | Isolated Resource |
| :--- | :--- | :--- |
| **PID** | `CLONE_NEWPID` | Process IDs (allows PID 1 inside container) |
| **NET** | `CLONE_NEWNET` | Network devices, IP addresses, routing tables, ports |
| **MNT** | `CLONE_NEWNS` | Filesystem mount points and layout |
| **IPC** | `CLONE_NEWIPC` | Inter-Process Communication (POSIX message queues, System V IPC) |
| **UTS** | `CLONE_NEWUTS` | Hostname and NIS domain name |
| **USER** | `CLONE_NEWUSER` | User and group IDs (map container root to unprivileged host user) |
| **CGROUP** | `CLONE_NEWCGROUP` | Root cgroup directory structure view |

---

## 2. Spawning Isolated Namespaces (`unshare`)

The `unshare` utility creates new namespaces and executes a command inside them:

```bash
# Create isolated PID, Mount, and UTS namespaces with new /proc
unshare --pid --fork --mount-proc --uts bash

# Inspect hostname isolation
hostname container-node
```

The `nsenter` command enters existing namespaces of running processes:

```bash
# Enter PID and NET namespace of process <PID>
nsenter --target <PID> --pid --net bash
```

---

## Summary

`unshare` and `nsenter` interact directly with Linux namespace syscalls (`clone`, `unshare`, `setns`).

---

## Lab Tasks

### Task 1: Explore Linux Namespace Types (`lnx-explore-process-namespaces`)
1. Start the lab:
   ```bash
   tld start lnx-explore-process-namespaces
   ```
2. Create directory `$HOME/ns-test`.
3. Inspect namespace symbolic links in `/proc/self/ns/` across all 7 Linux namespace types.
4. Write output summary `NAMESPACE_TYPES_EXPLORED` to `$HOME/ns-test/ns_types.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Create Isolated Namespace Environment (`lnx-create-isolated-namespace`)
1. Start the lab:
   ```bash
   tld start lnx-create-isolated-namespace
   ```
2. Create directory `$HOME/ns-test`.
3. Use `unshare` syntax to create isolated PID, MNT, and UTS namespace environments (`unshare --uts --pid --fork`).
4. Write summary `UNSHARE_NAMESPACE_CREATED` to `$HOME/ns-test/unshare_summary.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 3: Debug Namespace Isolation Issues (`lnx-debug-namespace-isolation`)
1. Start the lab:
   ```bash
   tld start lnx-debug-namespace-isolation
   ```
2. Create directory `$HOME/ns-test`.
3. Troubleshoot namespace isolation problems (unshared mount points, hostname leakage).
4. Write diagnosis output line `NAMESPACE_ISOLATION_DEBUGGED` to `$HOME/ns-test/ns_debug.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
