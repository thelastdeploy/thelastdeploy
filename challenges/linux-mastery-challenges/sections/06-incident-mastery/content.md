# Incident & Forensic Mastery

Demonstrate mastery of production incident response, volatile memory/network state preservation, and forensic timeline correlation.

Incident mastery tests your ability to handle active security and operational outages: preserving system evidence (`/proc/[pid]`, volatile RAM, active connections), building unified timeline logs, and containing breaches.


---

## Lab Tasks

### Task 1: Investigate Production Incident (`lnx-investigate-linux-production-incident`)
1. Start the lab:
   ```bash
   tld start lnx-investigate-linux-production-incident
   ```
2. Create directory `$HOME/mastery-incident`.
3. Preserve volatile process state, reconstruct security event timeline, and isolate unauthorized persistence.
4. Write `PRODUCTION_INCIDENT_INVESTIGATION_MASTERED` into `$HOME/mastery-incident/incident_mastery.log`.
5. Validate your solution:
   ```bash
   tld check
   ```
