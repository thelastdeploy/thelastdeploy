# Advanced Policy Routing & Multiple Tables

Standard Linux routing uses a single main routing table based on packet destination IP. **Policy Routing** allows routing decisions based on source IP, interface, TOS, or packet marks by evaluating multiple routing tables.

---

## 1. Multiple Routing Tables (`/etc/iproute2/rt_tables`)

Linux supports up to 252 custom routing tables. Table definitions are registered in `/etc/iproute2/rt_tables`:

```text
200 custom_table
```

Inspect rules and table entries:

```bash
# View routing policy rules
ip rule show

# View routes in a specific routing table
ip route show table 200
```

---

## 2. Policy Routing Rules (`ip rule`)

Add routing policy rules to select routing tables based on source IP:

```bash
# Add a policy rule for source IP 192.168.10.0/24 to use table 200
ip rule add from 192.168.10.0/24 table 200

# Add default gateway route inside table 200
ip route add default via 10.0.0.1 dev eth1 table 200

# Test routing lookup path for a specific source/destination
ip route get 8.8.8.8 from 192.168.10.50
```

---

## Summary

Policy routing enables multi-homed servers and VPN gateways to route traffic conditionally based on packet attributes.

---

## Lab Tasks

### Task 1: Configure Policy Routing Rules (`lnx-configure-policy-routing`)
1. Start the lab:
   ```bash
   tld start lnx-configure-policy-routing
   ```
2. Create directory `$HOME/route-test` and inspect routing rules:
   ```bash
   mkdir -p "$HOME/route-test"
   ip rule show
   ```
3. Record the inspection marker into `$HOME/route-test/rules_summary.txt`:
   ```bash
   echo "POLICY_ROUTING_INSPECTED" > "$HOME/route-test/rules_summary.txt"
   ```
4. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Debug Multi-Route Network Configuration (`lnx-debug-multi-route-network`)
1. Start the lab:
   ```bash
   tld start lnx-debug-multi-route-network
   ```
2. Create directory `$HOME/route-test` and run the route lookup test:
   ```bash
   mkdir -p "$HOME/route-test"
   ip route get 127.0.0.1
   ```
3. Record the lookup result into `$HOME/route-test/route_debug.txt`:
   ```bash
   echo "ROUTE_LOOKUP_SUCCESS: 127.0.0.1" > "$HOME/route-test/route_debug.txt"
   ```
4. Validate your solution:
   ```bash
   tld check
   ```
