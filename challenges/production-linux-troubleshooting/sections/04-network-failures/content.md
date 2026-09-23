# Network Outages & Service Binding Failures

Production network outages stem from socket binding conflicts, blocked firewall chains, interface routing drops, or misconfigured DNS resolution.

---

## 1. Network Outage Diagnostic Layer Walkthrough

```text
Layer 1/2 (Physical/Link) ---> Layer 3 (Routing & IP) ---> Layer 4 (Socket & Port) ---> Layer 7 (Application)
  ip link show                  ip route / ping             ss -tulpn / firewall        curl -v http://...
```

---

## 2. Diagnostic Commands

```bash
# 1. Verify socket binding and interface address
ss -tulpn | grep :80

# 2. Test local socket connection bypassing DNS
curl -iv http://127.0.0.1:8080/health

# 3. Check firewall filtering rules
iptables -L -n -v

# 4. Check DNS name resolution
dig +short api.production.internal
```

---

## Summary

Systematic socket (`ss`), HTTP (`curl`), firewall (`iptables`), and DNS (`dig`) testing pinpoints network outage layers.

---

## Lab Tasks

### Task 1: Investigate Production Network Connectivity Failure (`lnx-investigate-production-connectivity`)
1. Start the lab:
   ```bash
   tld start lnx-investigate-production-connectivity
   ```
2. Create directory `$HOME/net-outage-test`.
3. Investigate network connectivity failure using `ss`, `curl`, and `iptables`.
4. Write output summary line `NETWORK_CONNECTIVITY_FAILURE_DIAGNOSED` to `$HOME/net-outage-test/net_diag.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Recover Broken Network Service (`lnx-recover-broken-network-service`)
1. Start the lab:
   ```bash
   tld start lnx-recover-broken-network-service
   ```
2. Create directory `$HOME/net-outage-test`.
3. Repair broken firewall rule or socket binding to restore network service flow.
4. Write output summary `BROKEN_NETWORK_SERVICE_RECOVERED` to `$HOME/net-outage-test/net_recovered.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
