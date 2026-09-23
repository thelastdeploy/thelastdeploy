# Linux Mastery Grand Capstone

The ultimate Linux track capstone challenge: diagnose, repair, harden, optimize, and verify an enterprise Linux environment suffering from un-isolated multi-subsystem breakdowns.

In this 150 XP Grand Capstone challenge—the final milestone of the Linux Track—you take full control of a degraded production environment.

```text
Production Linux Environment
          │
          ├── Application failure (Socket path & permission errors)
          ├── Resource pressure (Memory leak & CPU starvation)
          ├── Network issue (Firewall drop & DNS resolver mismatch)
          ├── Service dependency (Un-ordered systemd unit files)
          ├── Security weakness (SSH password login & root access enabled)
          └── Configuration problem (Un-tuned sysctl parameters)
                    │
                    ▼
              YOU INVESTIGATE
                    │
        ┌───────────┼───────────┐
        ▼           ▼           ▼
      Diagnose    Repair      Harden
        │           │           │
        └───────────┼───────────┘
                    ▼
             Verify everything
```

### Grand Capstone Workflow
1. **Diagnose**: Gather evidence across logs, processes, memory/CPU, storage, network, systemd, security, and kernel interfaces.
2. **Repair**: Restore application connectivity, kill rogue processes, expand LVM storage, fix DNS/firewall, and fix systemd dependencies.
3. **Harden**: Disable SSH password/root logins, enforce stateful firewall rules, and apply cgroup resource limits.
4. **Optimize**: Apply sysctl kernel tuneables for network and dirty page writeback.
5. **Verify**: Execute end-to-end verification and write the master Linux track completion sign-off.


---

## Lab Tasks

### Task 1: Complete Linux Mastery Grand Capstone (`lnx-complete-linux-mastery`)
1. Start the lab:
   ```bash
   tld start lnx-complete-linux-mastery
   ```
2. Create directory `$HOME/linux-mastery`.
3. Diagnose, repair, harden, tune, and verify all broken subsystems across the entire Linux server stack.
4. Write `GRAND_LINUX_MASTERY_TRACK_COMPLETED_SUCCESSFULLY` into `$HOME/linux-mastery/grand_mastery_completion.log`.
5. Validate your solution:
   ```bash
   tld check
   ```
