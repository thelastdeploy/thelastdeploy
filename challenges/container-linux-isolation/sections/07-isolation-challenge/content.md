# Container Isolation Debugging Capstone Challenge

In this expert capstone challenge, a custom container environment suffers from isolation flaws: leaked host mount points, un-throttled cgroup memory allocation, and missing network namespace separation. Your task is to diagnose the isolation flaws, apply fixes across namespaces, cgroups, and OverlayFS, and document proof of complete process isolation.

---

## Troubleshooting Checklist

1. **Namespace Isolation**: Confirm PID, NET, MNT, and UTS namespaces are unshared.
2. **Resource Throttling**: Confirm cgroup v2 limits (`memory.max` / `cpu.max`) are active.
3. **Filesystem Boundaries**: Confirm OverlayFS `lowerdir`/`upperdir` union mount hides host root.
4. **Security Caps**: Confirm privileged capabilities (`CAP_SYS_ADMIN`) are dropped.

---

## Summary

Diagnosing and repairing container isolation flaws ensures processes remain securely contained without host leakage.

---

## Lab Tasks

### Task 1: Debug Broken Container Isolation Capstone (`lnx-debug-broken-container-isolation`)
1. Start the lab:
   ```bash
   tld start lnx-debug-broken-container-isolation
   ```
2. Create directory `$HOME/isolation-challenge`.
3. Identify isolation flaws across namespaces, cgroups, and OverlayFS, applying fixes.
4. Write proof summary line `CONTAINER_ISOLATION_REPAIRED: SUCCESS` into `$HOME/isolation-challenge/isolation_fix.log`.
5. Validate your solution:
   ```bash
   tld check
   ```
