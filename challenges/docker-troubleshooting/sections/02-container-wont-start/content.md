## Container Won't Start

One of the most frustrating Docker issues is when a container fails to start entirely or exits immediately. Common causes include:
1. **Entrypoint Script Failures**: Missing files, syntax errors, or incorrect script execute permissions.
2. **Address Already In Use**: The host port you are mapping to is already occupied by another running process or container.
3. **Resource Exhaustion**: The container gets OOM (Out Of Memory) killed immediately upon launch.

---

### Port Collisions

When you launch a container with a port binding, e.g., `-p 80:80`, the Docker daemon attempts to bind to port 80 on the host machine. If another container or service (like apache/nginx running natively) is already listening on that port, you will receive an error:
`docker: Error response from daemon: driver failed programming external connectivity on endpoint ... Bind for 0.0.0.0:80 failed: port is already allocated.`

To troubleshoot:
1. Find what container is occupying the port:
   ```bash
   docker ps --filter "publish=PORT"
   ```
2. Or locate native processes occupying the port:
   ```bash
   sudo lsof -i :PORT
   ```
3. Stop or remove the occupying container or change your host port mapping.

---

## Lab Tasks

### Task 1: Fix container startup failure (`dkr-fix-startup-failure`)
1. Start the lab session:
   ```bash
   tld start dkr-fix-startup-failure
   ```
2. Verify that `host-port-occupier` is currently holding port 8084:
   ```bash
   docker ps --filter "name=host-port-occupier"
   ```
3. Stop and remove the occupying container:
   ```bash
   docker rm -f host-port-occupier
   ```
4. Start the required `nginx-service` container mapping port 8084 to port 80:
   ```bash
   docker run -d --name nginx-service -p 8084:80 nginx:alpine
   ```
5. Confirm that `nginx-service` is up and listening on port 8084:
   ```bash
   docker ps --filter "name=nginx-service"
   ```
6. Validate your solution:
   ```bash
   tld check
   ```
