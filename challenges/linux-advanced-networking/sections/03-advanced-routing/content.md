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
2. Create directory `$HOME/route-test`.
3. Inspect existing routing rules using `ip rule show`.
4. Output rule summary line `POLICY_ROUTING_INSPECTED` into `$HOME/route-test/rules_summary.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Debug Multi-Route Network Configuration (`lnx-debug-multi-route-network`)
1. Start the lab:
   ```bash
   tld start lnx-debug-multi-route-network
   ```
2. Create directory `$HOME/route-test`.
3. Perform route lookup test using `ip route get 127.0.0.1`.
4. Write output line `ROUTE_LOOKUP_SUCCESS: 127.0.0.1` into `$HOME/route-test/route_debug.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
