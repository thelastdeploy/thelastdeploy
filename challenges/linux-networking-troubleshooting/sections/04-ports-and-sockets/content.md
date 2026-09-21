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
