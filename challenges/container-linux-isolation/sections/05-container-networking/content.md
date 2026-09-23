# Container Network Isolation & Bridge Architectures

Container network isolation connects isolated network namespaces to the host network using virtual ethernet pairs (`veth`), Linux software bridges (`docker0` / `cni0`), and netfilter NAT forwarding.

---

## Container Network Packet Flow

```text
+-----------------------------------------------------------+
| Host OS                                                   |
|                                                           |
|  +---------------------------+                            |
|  | Container NetNS           |                            |
|  | Interface: eth0 (10.0.0.2)|                            |
|  +-------------+-------------+                            |
|                | (veth-pair)                              |
|                v                                          |
|  +-------------+-------------+                            |
|  | veth1234a                 |                            |
|  +-------------+-------------+                            |
|                |                                          |
|                v                                          |
|  +-------------+-------------+     +-------------------+  |
|  | Bridge (docker0/cni0)    | --> | iptables MASQUER  |  |  (Out to WAN)
|  | IP: 10.0.0.1             |     | (POSTROUTING)     |  |
|  +---------------------------+     +-------------------+  |
+-----------------------------------------------------------+
```

---

## Summary

Container networking combines Network Namespaces, `veth` interface pairs, Linux bridges, and `iptables` MASQUERADE NAT.

---

## Lab Tasks

### Task 1: Trace Container Network Isolation and veth Pairs (`lnx-trace-container-network-isolation`)
1. Start the lab:
   ```bash
   tld start lnx-trace-container-network-isolation
   ```
2. Create directory `$HOME/container-net-test`.
3. Trace network packet flow from container namespace across `veth` pair and bridge.
4. Write output summary line `CONTAINER_NET_TRACE_VERIFIED` to `$HOME/container-net-test/net_trace.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
