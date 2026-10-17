# Section 06 — Network Capture

When higher-level tools fail to reveal network issues, packet capture analysis (`tcpdump`) provides raw inspection of protocol frames traversing network interfaces.

## Packet Capture Fundamentals

- `tcpdump -i eth0`: Capture packets on interface `eth0`.
- `tcpdump -n`: Display IP addresses and port numbers numerically without resolving hostnames/services.
- `tcpdump port 80`: Filter packet stream for traffic matching TCP/UDP port 80.
- `tcpdump -c 10 -w capture.pcap`: Capture 10 packets and save to a PCAP capture file.

## Common Packet Inspection Scenarios

- **SYN without SYN-ACK**: Indicates firewall dropping packets or target host unreachable.
- **RST (Reset)**: Indicates target port closed or active firewall rejecting connections.
- **ICMP Destination Unreachable**: Router or host returning network unreachable notices.

---

## Lab Tasks

### Task 1: Inspect Network Traffic (`lnx-inspect-network-traffic`)
1. Start the lab:
   ```bash
   tld start lnx-inspect-network-traffic
   ```
2. Inspect the simulated network packet capture log in `$HOME/net-test/capture/tcpdump.log`:
   ```bash
   cat "$HOME/net-test/capture/tcpdump.log"
   ```
3. Identify the client source IP initiating the TCP handshake (`Flags [S]`) (`192.168.1.50`).
4. Write the client IP address (`192.168.1.50`) into `$HOME/net-test/client_ip.txt`:
   ```bash
   mkdir -p "$HOME/net-test"
   echo "192.168.1.50" > "$HOME/net-test/client_ip.txt"
   ```
5. Validate your solution:
   ```bash
   tld check
   ```
