# Section 05 — Network Services

When a network service process is active (`systemctl status webapp`), clients may still fail to connect due to port binding restrictions, host firewall rules (`iptables` / `nftables`), or proxy misconfigurations.

## Diagnostic Workflow

1. **Verify Process & Socket State**: Confirm the daemon is active and bound to the expected interface (`ss -tulpn`).
2. **Local Loopback Test**: Test connection directly from localhost (`curl -I http://127.0.0.1:8080` or `nc -zv 127.0.0.1 8080`).
3. **Firewall Rule Verification**: Audit active packet filtering rules (`sudo iptables -L -n -v` or `nft list ruleset`).
4. **Application HTTP Status Check**: Inspect return codes (200 OK vs 502 Bad Gateway / 503 Service Unavailable).

---

## Lab Tasks

### Task 1: Debug Service Connectivity (`lnx-debug-service-connectivity`)
1. Start the lab:
   ```bash
   tld start lnx-debug-service-connectivity
   ```
2. Inspect the service configuration in `$HOME/net-test/service_debug/app.conf`:
   ```bash
   cat "$HOME/net-test/service_debug/app.conf"
   ```
3. Update `BIND_ADDRESS="127.0.0.1"` to `BIND_ADDRESS="0.0.0.0"` so the service listens on all network interfaces:
   ```bash
   sed -i 's/BIND_ADDRESS="127.0.0.1"/BIND_ADDRESS="0.0.0.0"/' "$HOME/net-test/service_debug/app.conf"
   ```
4. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Trace Application Connection (`lnx-trace-application-connection`)
1. Start the lab:
   ```bash
   tld start lnx-trace-application-connection
   ```
2. Inspect the HTTP response headers in `$HOME/net-test/app_trace/curl_headers.txt`:
   ```bash
   cat "$HOME/net-test/app_trace/curl_headers.txt"
   ```
3. Identify the HTTP status code returned by the gateway server (`502`).
4. Write the numerical status code (`502`) into `$HOME/net-test/status_code.txt`:
   ```bash
   mkdir -p "$HOME/net-test"
   echo "502" > "$HOME/net-test/status_code.txt"
   ```
5. Validate your solution:
   ```bash
   tld check
   ```
