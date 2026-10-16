# Automated Remote Administration

Managing multi-server infrastructure requires batching remote SSH invocations across inventories of target hosts.

## 1. Batch Execution Across Host Lists

Looping over a list of hostnames or SSH client aliases:

```bash
HOSTS=("web1" "web2" "db1")

for HOST in "${HOSTS[@]}"; do
    echo "=== Running maintenance on $HOST ==="
    ssh "$HOST" "uptime; df -h /"
done
```

## 2. Pipe Local Scripts into Remote SSH

Execute a local script file directly on a remote server without copying it over first:

```bash
ssh user@remote.example.com 'bash -s' < local_audit_script.sh
```

## 3. Pseudo-Terminal Allocation Flags

- `ssh -t`: Forces pseudo-terminal allocation (required when running `sudo` commands on remote hosts).
- `ssh -T`: Disables pseudo-terminal allocation (useful for clean batch scripting and data piping).

---

## Lab Tasks

### Task 1: Perform Automated Remote Maintenance (`lnx-perform-remote-maintenance`)
1. Start the lab:
   ```bash
   tld start lnx-perform-remote-maintenance
   ```
2. Create directory `$HOME/ssh-test`.
3. Create an executable script `$HOME/ssh-test/maint_runner.sh` that iterates through hosts `web1`, `web2`, and `web3`, writing `MAINTENANCE_COMPLETE: <host>` for each into `$HOME/ssh-test/maint_execution.log`.
4. Ensure the script has executable permissions (`chmod +x`).
5. Validate your solution:
   ```bash
   tld check
   ```
