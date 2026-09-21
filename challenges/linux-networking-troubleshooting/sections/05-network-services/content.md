# Section 05 — Network Services

When a network service process is active (`systemctl status webapp`), clients may still fail to connect due to port binding restrictions, host firewall rules (`iptables` / `nftables`), or proxy misconfigurations.

## Diagnostic Workflow

1. **Verify Process & Socket State**: Confirm the daemon is active and bound to the expected interface (`ss -tulpn`).
2. **Local Loopback Test**: Test connection directly from localhost (`curl -I http://127.0.0.1:8080` or `nc -zv 127.0.0.1 8080`).
3. **Firewall Rule Verification**: Audit active packet filtering rules (`sudo iptables -L -n -v` or `nft list ruleset`).
4. **Application HTTP Status Check**: Inspect return codes (200 OK vs 502 Bad Gateway / 503 Service Unavailable).
