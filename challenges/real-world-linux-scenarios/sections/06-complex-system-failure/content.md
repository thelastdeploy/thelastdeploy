# Complex Cascading System Failures

Investigate and resolve multi-layer cascading failures where storage disk full events trigger database corruption, connection pool exhaustion, and web proxy failure.

In complex enterprise environments, single root causes trigger cascading multi-system failures across distinct layers. For example: an unrotated log file fills `/var/log` -> database write fails -> connection pool exhausts -> web proxy returns 502 -> monitoring system generates alert floods.

Resolving cascading failures requires systematic reverse dependency analysis.

---

## Lab Tasks

### Task 1: Correlate Multi-Layer System Failure (`lnx-correlate-multi-layer-system-failure`)
1. Start the lab session:
   ```bash
   tld start lnx-correlate-multi-layer-system-failure
   ```
2. Create the destination directory for cascading failure logs:
   ```bash
   mkdir -p "$HOME/complex-failure"
   ```
3. Trace the cascading failure chain across storage, database, and web proxy layers.
4. Fix underlying storage exhaustion, repair database state, and restart dependent proxy services.
5. Record the cascading recovery verification marker into `$HOME/complex-failure/cascading_recovery.log`:
   ```bash
   echo "CASCADING_MULTI_LAYER_FAILURE_RESOLVED" > "$HOME/complex-failure/cascading_recovery.log"
   ```
6. Verify file contents:
   ```bash
   cat "$HOME/complex-failure/cascading_recovery.log"
   ```
7. Validate your solution:
   ```bash
   tld check
   ```
