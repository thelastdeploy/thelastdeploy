# Network and Service Connectivity Failures

Troubleshoot network service outages caused by DNS resolution failures, MTU size mismatches, socket buffer overflow, and dropped packets.

Network failures in production systems are frequently subtle. Common symptoms include connection timeouts, truncated responses, or intermittent packet drops.

### Network Troubleshooting Stack
- **DNS Resolution**: `dig +trace domain.com`, `/etc/resolv.conf`, systemd-resolved status.
- **Port Listening & Routing**: `ss -tulpn`, `ip route`, `ip addr`.
- **Packet Path Inspection**: `tcpdump -nn -i any port 80`, `traceroute`, `ping -M do -s 1472`.


---

## Lab Tasks

### Task 1: Recover Broken Service Connectivity (`lnx-recover-broken-service-connectivity`)
1. Start the lab:
   ```bash
   tld start lnx-recover-broken-service-connectivity
   ```
2. Create directory `$HOME/net-failure`.
3. Diagnose service-to-service connection errors using `curl`, `dig`, and `nftables`/`iptables`.
4. Fix DNS resolver configuration and firewall drop rules.
5. Write `SERVICE_NETWORK_CONNECTIVITY_RESTORED` into `$HOME/net-failure/connectivity_recovery.log`.
6. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Trace Intermittent Network Drops (`lnx-trace-intermittent-network-failure`)
1. Start the lab:
   ```bash
   tld start lnx-trace-intermittent-network-failure
   ```
2. Inspect TCP queue overflow counters in `/proc/net/netstat` (`ListenOverflows`).
3. Tune `net.core.somaxconn` and fix path MTU fragmentation.
4. Write `INTERMITTENT_PACKET_DROPS_TRACED_AND_FIXED` into `$HOME/net-failure/network_drop_analysis.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
