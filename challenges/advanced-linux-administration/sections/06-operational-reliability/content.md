# Operational Reliability & Observability

Designing fault-tolerant Linux operations, synthetic health monitoring checks, automated recovery triggers, and log alert integration.

Operational reliability ensures that services self-heal when transient failures occur. System administrators implement health monitoring agents, automated failover triggers, and watchdog services.

### Systemd Watchdogs & Health Checks
- **Systemd Watchdog**: `WatchdogSec=30s` in unit files. Application ping must reset timer before expiration or systemd restarts process.
- **Health Verification**: Periodic HTTP / TCP probes triggering system recovery commands.


---

## Lab Tasks

### Task 1: Design Reliable Linux Service (`lnx-design-reliable-linux-service`)
1. Start the lab:
   ```bash
   tld start lnx-design-reliable-linux-service
   ```
2. Create directory `$HOME/reliability`.
3. Configure systemd watchdog timer supervision and synthetic health checking script.
4. Write `OPERATIONAL_RELIABILITY_HEALTHCHECK_ACTIVE` into `$HOME/reliability/reliability_design.log`.
5. Validate your solution:
   ```bash
   tld check
   ```
