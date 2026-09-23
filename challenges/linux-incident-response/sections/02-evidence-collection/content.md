# Volatile Process & Network Evidence Collection

Collecting digital evidence requires extracting detailed execution parameters from running processes, network connections, memory mappings, and active security credentials.

---

## 1. Process Artifact Collection (/proc/<pid>/)

The `/proc` filesystem contains raw process evidence:

```bash
# Capture full command-line invocation parameters
cat /proc/<PID>/cmdline | tr '\0' ' '

# Capture process environment variables (exported keys/paths)
cat /proc/<PID>/environ | tr '\0' '\n'

# Capture open file descriptors
ls -la /proc/<PID>/fd/

# Copy executable binary before process termination (useful for unlinked binaries)
cp /proc/<PID>/exe /tmp/recovered_malware_sample
```

---

## 2. Network Sockets & Connection Tracing

```bash
# Collect socket bindings with associated user and process PIDs
ss -anp

# Collect open files and network connections
lsof -P -n -i
```

---

## Summary

Extracting `/proc/<PID>/cmdline`, `/proc/<PID>/environ`, and copying `/proc/<PID>/exe` preserves process evidence for offline malware analysis.

---

## Lab Tasks

### Task 1: Collect System File & Environment Evidence (`lnx-collect-system-evidence`)
1. Start the lab:
   ```bash
   tld start lnx-collect-system-evidence
   ```
2. Create directory `$HOME/evidence-test`.
3. Collect system file and environment variable evidence (`/proc/<pid>/environ`, authorized_keys).
4. Write output summary line `SYSTEM_EVIDENCE_COLLECTED` to `$HOME/evidence-test/system_evidence.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Collect Volatile Process and Network Evidence (`lnx-collect-process-and-network-evidence`)
1. Start the lab:
   ```bash
   tld start lnx-collect-process-and-network-evidence
   ```
2. Create directory `$HOME/evidence-test`.
3. Collect volatile network connections (`ss -anp`) and process open file handles (`lsof`).
4. Write output summary `PROC_NET_EVIDENCE_COLLECTED` to `$HOME/evidence-test/proc_net_evidence.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
