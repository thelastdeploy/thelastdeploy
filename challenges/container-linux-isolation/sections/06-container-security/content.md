# Container Security, Capabilities & Seccomp

Container security enforces the principle of least privilege by dropping dangerous Linux Kernel Capabilities (e.g. `CAP_SYS_ADMIN`, `CAP_NET_ADMIN`, `CAP_SYS_RAWIO`) and restricting system calls via **Seccomp** (Secure Computing Mode) profiles.

---

## 1. Linux Capabilities in Containers

Instead of binary all-or-nothing root privileges, Linux splits root powers into distinct capabilities. Container runtimes drop most capabilities by default:

```bash
# View current process capability mask
cat /proc/self/status | grep Cap

# Decode capability bitmask
capsh --decode=0000000000000000
```

Commonly dropped capabilities:
- `CAP_SYS_ADMIN`: Prevents mounting filesystems or creating new namespaces.
- `CAP_NET_ADMIN`: Prevents modifying network interface configurations or firewall rules.
- `CAP_SYS_RAWIO`: Prevents raw physical I/O disk access.

---

## 2. Seccomp Syscall Filtering

Seccomp restricts system calls available to a process. A default container Seccomp profile blocks dangerous syscalls like `reboot`, `kexec_load`, and `sys_ptrace`.

---

## Summary

Dropping kernel capabilities and enforcing Seccomp syscall profiles prevents container breakout exploits.

---

## Lab Tasks

### Task 1: Investigate Container Security Capabilities and Seccomp (`lnx-investigate-container-security`)
1. Start the lab:
   ```bash
   tld start lnx-investigate-container-security
   ```
2. Create directory `$HOME/container-sec-test`.
3. Inspect Linux process capabilities (`CapEff` in `/proc/self/status`) and Seccomp profiles.
4. Write output line `CONTAINER_CAPABILITIES_INVESTIGATED` to `$HOME/container-sec-test/sec_caps.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
