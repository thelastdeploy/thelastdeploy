# Section 04 — Ports & Sockets

Services communicate over network sockets identified by transport protocol (TCP/UDP), IP address bindings, and port numbers.

## Socket Inspection Tools

- `ss -tulpn`: Modern utility displaying TCP (`-t`), UDP (`-u`), listening (`-l`), numerical addresses (`-n`), and process names/PIDs (`-p`).
- `netstat -tulpn`: Legacy socket statistics command.
- `lsof -i :<port>`: Identify processes utilizing a specific port number.

## Socket Binding Scope

- `127.0.0.1:8080` (Localhost loopback): Reachable **only** within the local host; remote hosts cannot connect.
- `0.0.0.0:8080` (All interfaces): Listens on all IPv4 addresses bound to the system.
- `:::8080` (All IPv6 interfaces): Listens on all IPv6 interface addresses.

---

## Lab Tasks

### Task 1: Investigate Listening Services (`lnx-investigate-listening-services`)
1. Start the lab:
   ```bash
   tld start lnx-investigate-listening-services
   ```
2. Inspect the listening socket output in `$HOME/net-test/sockets/ss_output.txt`:
   ```bash
   cat "$HOME/net-test/sockets/ss_output.txt"
   ```
3. Identify the process name (`nginx`) and PID (`4251`) listening on port `8080`.
4. Write the PID (`4251`) into `$HOME/net-test/port_8080_pid.txt`:
   ```bash
   mkdir -p "$HOME/net-test"
   echo "4251" > "$HOME/net-test/port_8080_pid.txt"
   ```
5. Validate your solution:
   ```bash
   tld check
   ```
