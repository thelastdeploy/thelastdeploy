## Container-to-Container Communication

Containers frequently need to talk to other containers on the same host (e.g. a web application backend talking to a database or a caching daemon).

---

## 1. Network Namespaces and Communication

When containers are launched on the same Docker network, they are assigned private IP addresses in that network segment (e.g. `172.18.0.2` and `172.18.0.3`). They can communicate directly using these IPs.

However, container IPs are ephemeral — they can change if a container is restarted or recreated. To establish reliable communication, we must use **hostnames** instead of IPs.

---

## 2. DNS Resolution on Custom Networks

Docker provides built-in automatic **DNS resolution** for containers, but **only on user-defined networks**.

If you connect two containers `web-app` and `db-server` to a custom bridge network named `app-net`:
1. `web-app` can make requests to `http://db-server:5432` directly.
2. Docker's embedded DNS server will automatically resolve the name `db-server` to its correct private IP address.

*(Note: Name resolution does NOT work in the default bridge network `docker0`).*

---

## Lab Tasks

### Task 1: Connect two containers (`dkr-connect-two-containers`)
1. Start the lab session:
   ```bash
   tld start dkr-connect-two-containers
   ```
2. A custom bridge network named `lab-net` has been pre-created with two containers running in it:
   - `server-target` (an Nginx server on port 80)
   - `client-source` (an Alpine container with curl installed)
3. Execute `curl` from inside `client-source` to fetch the homepage of `server-target` and save the response to `~/docker-test/fetched_page.txt`:
   ```bash
   mkdir -p "$HOME/docker-test"
   docker exec client-source curl -s http://server-target > "$HOME/docker-test/fetched_page.txt"
   ```
4. Verify the saved file contents:
   ```bash
   head -n 5 "$HOME/docker-test/fetched_page.txt"
   ```
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Debug connection failure (`dkr-debug-connection-failure`)
1. Start the lab session:
   ```bash
   tld start dkr-debug-connection-failure
   ```
2. Two containers are currently running:
   - `backend-service` (attached to custom network `debug-net`)
   - `client-app` (attached to the default `bridge` network)
3. Connect `client-app` to the `debug-net` network:
   ```bash
   docker network connect debug-net client-app
   ```
4. Execute `curl` from inside `client-app` to fetch the homepage of `backend-service` and save the response to `~/docker-test/debug_output.txt`:
   ```bash
   mkdir -p "$HOME/docker-test"
   docker exec client-app curl -s http://backend-service > "$HOME/docker-test/debug_output.txt"
   ```
5. Verify the saved file contents:
   ```bash
   head -n 5 "$HOME/docker-test/debug_output.txt"
   ```
6. Validate your solution:
   ```bash
   tld check
   ```
