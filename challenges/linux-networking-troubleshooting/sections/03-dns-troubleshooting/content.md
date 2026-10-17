# Section 03 — DNS Troubleshooting

When a host can reach external IP addresses directly (`ping 8.8.8.8`) but fails when using domain names (`curl example.com`), the underlying cause is DNS resolution failure rather than network layer 3 disruption.

## Diagnostic Utilities

- `nslookup <domain>`: Simple name resolution lookup utility.
- `dig <domain>`: Flexible DNS query tool showing record types, TTL, query timing, and responding nameserver.
- `host <domain>`: Concise domain lookup tool.

## Key Files & Services

- `/etc/resolv.conf`: Configures local DNS resolver addresses (`nameserver x.x.x.x`) and search domains.
- `/etc/hosts`: Static local IP-to-hostname mappings that take precedence over DNS queries by default.
- `systemd-resolved`: Local stub resolver service caching DNS queries.

---

## Lab Tasks

### Task 1: Investigate DNS Resolution (`lnx-investigate-dns-resolution`)
1. Start the lab:
   ```bash
   tld start lnx-investigate-dns-resolution
   ```
2. Inspect the DNS query log in `$HOME/net-test/dns/dig_output.txt`:
   ```bash
   cat "$HOME/net-test/dns/dig_output.txt"
   ```
3. Identify the resolved IP address for `internal.service.local` (`10.250.0.15`).
4. Write the resolved IP address into `$HOME/net-test/resolved_ip.txt`:
   ```bash
   mkdir -p "$HOME/net-test"
   echo "10.250.0.15" > "$HOME/net-test/resolved_ip.txt"
   ```
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Fix DNS Configuration (`lnx-fix-dns-configuration`)
1. Start the lab:
   ```bash
   tld start lnx-fix-dns-configuration
   ```
2. Inspect `$HOME/net-test/resolv_fix/resolv.conf`:
   ```bash
   cat "$HOME/net-test/resolv_fix/resolv.conf"
   ```
3. Update the invalid nameserver `0.0.0.0` to `8.8.8.8`:
   ```bash
   sed -i 's/nameserver 0.0.0.0/nameserver 8.8.8.8/' "$HOME/net-test/resolv_fix/resolv.conf"
   ```
4. Validate your solution:
   ```bash
   tld check
   ```
