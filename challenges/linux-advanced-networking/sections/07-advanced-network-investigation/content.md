# Advanced Network Isolation Investigation

When network connectivity fails in isolated multi-tenant or containerized environments, engineers must systematically trace layer-by-layer: interface state -> IP/subnet configuration -> routing rules -> bridge attachments -> netfilter rules.

---

## Network Isolation Troubleshooting Flowchart

1. **Layer 1 / 2 (Interface & Link)**: Is the interface UP? Is it attached to the correct bridge? (`ip link`, `bridge link`)
2. **Layer 3 (IP & Route)**: Are IP address and CIDR prefix correct? Is there a valid default or specific route? (`ip addr`, `ip route`)
3. **Layer 4 / Firewall**: Are netfilter rules dropping ICMP or target TCP/UDP ports? (`iptables -L -v -n`, `nft list ruleset`)
4. **Namespace Isolation**: Is the interface located inside the intended network namespace? (`ip netns exec <ns> ip addr`)

---

## Summary

Systematic layer-by-layer troubleshooting prevents misdiagnosing firewall drops as routing or link failures.

---

## Lab Tasks

### Task 1: Investigate Network Isolation Issues (`lnx-investigate-network-isolation`)
1. Start the lab:
   ```bash
   tld start lnx-investigate-network-isolation
   ```
2. Create directory `$HOME/net-inv-test`:
   ```bash
   mkdir -p "$HOME/net-inv-test"
   ```
3. Record the multi-layer network diagnostic investigation result into `$HOME/net-inv-test/diag_report.txt`:
   ```bash
   echo "ISOLATION_CHECK: ALL_LAYERS_HEALTHY" > "$HOME/net-inv-test/diag_report.txt"
   ```
4. Validate your solution:
   ```bash
   tld check
   ```
