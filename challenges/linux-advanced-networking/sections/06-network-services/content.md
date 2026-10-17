# Network Service Integration & Tracing

Diagnosing complex networking issues requires validating socket bindings, interface associations, and live packet stream flows using diagnostic utilities like `ss`, `netstat`, `tcpdump`, and `tshark`.

---

## 1. Socket Binding & Connection Inspection (`ss`)

```bash
# List all listening TCP/UDP sockets with process PIDs
ss -tulpn

# Display active TCP connections with numerical IP and port numbers
ss -tun

# Filter sockets by specific port
ss -tulpn 'sport = :80'
```

---

## 2. Packet Capture & Traffic Tracing (`tcpdump`)

`tcpdump` captures live network packets passing through network interfaces:

```bash
# Capture packets on eth0 on port 80
tcpdump -i eth0 -n port 80

# Capture 10 ICMP packets on veth-host interface
tcpdump -i veth-host -n -c 10 icmp

# Capture packets and write raw pcap file for analysis
tcpdump -i eth0 -w /tmp/capture.pcap
```

---

## Summary

Combining socket inspection (`ss`) with packet capture (`tcpdump`) pinpoints binding mismatches and network transmission failures.

---

## Lab Tasks

### Task 1: Debug Advanced Network Service Binding (`lnx-debug-advanced-network-service`)
1. Start the lab:
   ```bash
   tld start lnx-debug-advanced-network-service
   ```
2. Create directory `$HOME/svc-net-test` and inspect network socket bindings:
   ```bash
   mkdir -p "$HOME/svc-net-test"
   ss -tun
   ```
3. Record the socket bindings marker into `$HOME/svc-net-test/sockets.txt`:
   ```bash
   echo "SOCKET_BINDINGS_INSPECTED" > "$HOME/svc-net-test/sockets.txt"
   ```
4. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Trace Network Connection Flow (`lnx-trace-network-connection`)
1. Start the lab:
   ```bash
   tld start lnx-trace-network-connection
   ```
2. Create directory `$HOME/svc-net-test` and record packet tracing verification:
   ```bash
   mkdir -p "$HOME/svc-net-test"
   echo "PACKET_TRACE_VERIFIED" > "$HOME/svc-net-test/trace_summary.txt"
   ```
3. Validate your solution:
   ```bash
   tld check
   ```
