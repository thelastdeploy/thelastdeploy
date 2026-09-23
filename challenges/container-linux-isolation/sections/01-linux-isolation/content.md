# Linux Process Isolation Fundamentals

Containers are not virtual machines with hardware hypervisors; they are standard Linux processes isolated by Linux kernel primitives. Understanding process isolation requires exploring how the kernel restricts what a process can see (Namespaces) and what resources a process can consume (Control Groups).

---

## 1. Containers vs Virtual Machines

```text
+---------------------------------+     +---------------------------------+
| VIRTUAL MACHINES                |     | CONTAINERS                      |
|                                 |     |                                 |
|  App A      App B      App C    |     |  App A      App B      App C    |
|  Guest OS   Guest OS   Guest OS |     |  Bins/Libs  Bins/Libs  Bins/Libs|
|  +---------------------------+  |     |  +---------------------------+  |
|  | Hypervisor (KVM/QEMU)   |  |     |  | Namespaces & cgroups     |  |
|  +---------------------------+  |     |  +---------------------------+  |
|  Host Linux Kernel              |     |  Shared Host Linux Kernel       |
+---------------------------------+     +---------------------------------+
```

---

## 2. Process Visibility & Boundaries

A containerized process is visible on the host OS process table (`ps aux`), but inside its isolated PID namespace, it appears as `PID 1` with restricted visibility of host processes.

```bash
# View process namespaces on the host
ls -l /proc/self/ns/

# View process credentials and capabilities
cat /proc/self/status | grep -E "Cap|Spec|Seccomp"
```

---

## Summary

Linux container isolation relies on shared kernel primitives to enforce process visibility boundaries without hypervisor overhead.

---

## Lab Tasks

### Task 1: Explore Linux Process Isolation (`lnx-explore-linux-process-isolation`)
1. Start the lab:
   ```bash
   tld start lnx-explore-linux-process-isolation
   ```
2. Create directory `$HOME/iso-test`.
3. Inspect process isolation mechanisms and host process visibility.
4. Write output summary line `PROCESS_ISOLATION_EXPLORED` to `$HOME/iso-test/isolation_basics.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Investigate Isolated Process States (`lnx-investigate-isolated-processes`)
1. Start the lab:
   ```bash
   tld start lnx-investigate-isolated-processes
   ```
2. Create directory `$HOME/iso-test`.
3. Investigate process attributes in isolated environments vs host namespace (`/proc/<pid>/ns/`).
4. Write summary output `ISOLATED_PROCESSES_INVESTIGATED` to `$HOME/iso-test/proc_isolation.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
