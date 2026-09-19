## Storage Recovery Challenge

### Incident Scenario
A production log archive folder `$HOME/storage-challenge` has triggered an automated alert. Stale crash dumps and archived log files are filling up the storage quota, threatening application stability.

Your goal is to inspect the directory, identify the unneeded archive files, and safely remove them to free up disk space while preserving active service logs.

---

## Safety Requirements
1. **Preserve Active Logs**: Do NOT delete `$HOME/storage-challenge/active_app.log` or `$HOME/storage-challenge/active_service.log`.
2. **Remove Stale Archives**: Safely remove all stale `.tar.gz` and `.dump` log archives inside `$HOME/storage-challenge/archives/`.

---

## Lab Tasks

### Task 1: Recover Disk Space (`lnx-recover-disk-space`)
1. Start the lab:
   ```bash
   tld start lnx-recover-disk-space
   ```
2. Navigate to `$HOME/storage-challenge`.
3. Remove the stale archive files in `$HOME/storage-challenge/archives/` (`crash_2025.dump`, `old_logs.tar.gz`).
4. Keep the active log files intact (`active_app.log`, `active_service.log`).
5. Validate your solution:
   ```bash
   tld check
   ```
