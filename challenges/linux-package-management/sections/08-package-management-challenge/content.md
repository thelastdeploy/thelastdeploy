## Package Management Recovery Challenge

### Incident Scenario
An automated system update process crashed mid-installation on a deployment host. The interrupted state has left a lock file in `$HOME/pkg-challenge/locks/frontend.lock` and marked package `app-service` as `half-configured` in `$HOME/pkg-challenge/status.log`.

Your goal is to inspect the incident directory, remove the stale lock file, and record the recovered package name to restore system deployment capabilities.

---

## Lab Tasks

### Task 1: Recover Broken Environment (`lnx-recover-broken-environment`)
1. Start the lab:
   ```bash
   tld start lnx-recover-broken-environment
   ```
2. Inspect `$HOME/pkg-challenge`.
3. Clear the stale lock file `$HOME/pkg-challenge/locks/frontend.lock`.
4. Inspect `$HOME/pkg-challenge/status.log` to identify the package marked as `half-configured`.
5. Save the recovered package name (`app-service`) to `$HOME/pkg-challenge/recovered_package.txt`.
6. Validate your solution:
   ```bash
   tld check
   ```
