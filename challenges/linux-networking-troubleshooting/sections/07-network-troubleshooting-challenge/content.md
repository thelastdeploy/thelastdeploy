# Section 07 — Network Troubleshooting Challenge

In this capstone challenge, an internal microservice application has become unreachable for end users. You must perform an end-to-end network diagnosis:

1. Validate local resolver (`resolv.conf`) configuration.
2. Confirm listening socket binding (`0.0.0.0` vs `127.0.0.1`).
3. Repair service connectivity and mark application health as operational.

---

## Lab Tasks

### Task 1: Recover Broken Connectivity (`lnx-recover-broken-connectivity`)
1. Start the lab:
   ```bash
   tld start lnx-recover-broken-connectivity
   ```
2. Update `$HOME/net-challenge/config/server.env` so `LISTEN_IP` is set to `0.0.0.0`:
   ```bash
   sed -i 's/LISTEN_IP="127.0.0.1"/LISTEN_IP="0.0.0.0"/' "$HOME/net-challenge/config/server.env"
   ```
3. Add `nameserver 8.8.8.8` to `$HOME/net-challenge/config/resolv.conf`:
   ```bash
   echo "nameserver 8.8.8.8" >> "$HOME/net-challenge/config/resolv.conf"
   ```
4. Set `$HOME/net-challenge/status/app.status` to `CONNECTIVITY: RESTORED`:
   ```bash
   echo "CONNECTIVITY: RESTORED" > "$HOME/net-challenge/status/app.status"
   ```
5. Validate your solution:
   ```bash
   tld check
   ```
