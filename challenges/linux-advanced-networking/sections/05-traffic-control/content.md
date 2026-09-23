# Traffic Shaping & Traffic Control (tc)

The Linux Traffic Control subsystem (`tc`) manages packet queuing, rate limiting, network delay simulation, and packet loss testing using queuing disciplines (qdiscs).

---

## 1. Traffic Control Architecture

`tc` components operate at the network egress queue:

- **Qdisc (Queuing Discipline)**: Algorithm that manages the device packet queue (e.g., `pfifo_fast`, `fq_codel`, `tbf`, `netem`).
- **Class**: Hierarchical bandwidth allocation bucket under classful qdiscs (`htb`).
- **Filter**: Classifier rules mapping packets to specific classes.

---

## 2. Managing Traffic Control with `tc`

```bash
# Show current qdiscs on all network interfaces
tc qdisc show

# Add simulated latency (100ms) to eth0 interface using netem
tc qdisc add dev eth0 root netem delay 100ms

# Limit bandwidth on eth0 to 1mbit using Token Bucket Filter (tbf)
tc qdisc add dev eth0 root tbf rate 1mbit burst 32kbit latency 40ms

# Delete root qdisc settings on eth0 (restore default)
tc qdisc del dev eth0 root
```

---

## Summary

`tc` enables precise network rate limiting and fault injection testing for distributed applications.

---

## Lab Tasks

### Task 1: Control Network Traffic Shaping with tc (`lnx-control-network-traffic`)
1. Start the lab:
   ```bash
   tld start lnx-control-network-traffic
   ```
2. Create directory `$HOME/tc-test`.
3. Inspect traffic control queuing disciplines using `tc qdisc show`.
4. Write output summary `TC_QDISC_INSPECTED` to `$HOME/tc-test/tc_summary.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
