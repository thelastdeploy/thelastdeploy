# Section 02 — Routing

Linux kernel routing tables determine how outgoing IP packets are forwarded based on destination subnet criteria.

## Routing Tools

- `ip route`: Display and modify kernel IPv4 routing table entries.
- `route -n`: Legacy utility showing numerical IP routing tables.
- `ip route get <destination-ip>`: Perform a dry-run lookup to determine which egress interface and gateway IP will be used to reach a specific destination.

## Key Concepts

- **Default Gateway**: The `default via <gateway-ip> dev <interface>` entry handles all traffic without specific subnet matches.
- **Directly Connected Subnets**: Routes automatically generated when an IP address and netmask are assigned to an active interface.

---

## Lab Tasks

### Task 1: Inspect Routing Table (`lnx-inspect-routing-table`)
1. Start the lab:
   ```bash
   tld start lnx-inspect-routing-table
   ```
2. Inspect the simulated routing rules in `$HOME/net-test/routing/routes.txt`:
   ```bash
   cat "$HOME/net-test/routing/routes.txt"
   ```
3. Identify the default gateway IP (`192.168.1.1`) and write it into `$HOME/net-test/default_gateway.txt`:
   ```bash
   mkdir -p "$HOME/net-test"
   echo "192.168.1.1" > "$HOME/net-test/default_gateway.txt"
   ```
4. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Diagnose Routing Problem (`lnx-diagnose-routing-problem`)
1. Start the lab:
   ```bash
   tld start lnx-diagnose-routing-problem
   ```
2. Inspect `$HOME/net-test/routing_problem/routes.conf` and `$HOME/net-test/routing_problem/diag.txt`:
   ```bash
   cat "$HOME/net-test/routing_problem/diag.txt"
   cat "$HOME/net-test/routing_problem/routes.conf"
   ```
3. Update the unreachable gateway `192.168.99.99` in `ROUTE_2` to `10.0.0.254`:
   ```bash
   sed -i 's/192.168.99.99/10.0.0.254/' "$HOME/net-test/routing_problem/routes.conf"
   ```
4. Validate your solution:
   ```bash
   tld check
   ```
