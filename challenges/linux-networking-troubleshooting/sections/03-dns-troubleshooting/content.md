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
