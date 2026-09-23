# LVM Diagnostics & Recovery

When LVM components fail due to disk corruption or missing metadata, administrators scan devices and inspect metadata archives stored in `/etc/lvm/archive/` and `/etc/lvm/backup/`.

---

## 1. LVM Scanner & Scan Commands

```bash
# Scan system for Physical Volumes, Volume Groups, and Logical Volumes
pvscan
vgscan
lvscan
```

---

## 2. Metadata Backup & Restoration (`vgcfgrestore`)

LVM automatically backs up metadata changes in `/etc/lvm/backup/`:

```bash
# View metadata backup files
ls -l /etc/lvm/backup/

# Restore volume group metadata from backup file
vgcfgrestore -f /etc/lvm/backup/vg_data vg_data
```

---

## Summary

Scanner tools (`pvscan`/`vgscan`) and metadata backups (`vgcfgrestore`) restore lost LVM structures.

---

## Lab Tasks

### Task 1: Diagnose LVM Configuration Problems (`lnx-diagnose-lvm-problem`)
1. Start the lab:
   ```bash
   tld start lnx-diagnose-lvm-problem
   ```
2. Create directory `$HOME/lvm-diag`.
3. Inspect LVM scanner commands (`pvscan`, `vgscan`, `lvscan`).
4. Write output line `LVM_DIAGNOSTICS_COMPLETED` to `$HOME/lvm-diag/diag_report.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Recover LVM Storage State (`lnx-recover-lvm-storage`)
1. Start the lab:
   ```bash
   tld start lnx-recover-lvm-storage
   ```
2. Create directory `$HOME/lvm-diag`.
3. Document `vgcfgrestore` metadata recovery syntax.
4. Write output summary `VGCFGRESTORE_RECOVERY_VERIFIED` into `$HOME/lvm-diag/recovery_summary.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
