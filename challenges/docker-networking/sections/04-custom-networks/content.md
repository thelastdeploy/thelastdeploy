## Custom Networks

To build robust, isolated microservices, Docker allows you to create your own user-defined networks. Containers on these custom networks benefit from name-based DNS lookup and network isolation.

---

## 1. Creating Custom Networks (`docker network create`)

You can create a custom network using the `docker network create` command. By default, this creates a **bridge** network:

```bash
docker network create my-custom-net
```

### Useful CLI Commands
* **List networks**:
  ```bash
  docker network ls
  ```
* **Inspect network details**:
  ```bash
  docker network inspect my-custom-net
  ```
* **Remove network**:
  ```bash
  docker network rm my-custom-net
  ```

---

## 2. Attaching and Detaching Containers

You can connect a running container to a network on the fly without restarting it:

```bash
docker network connect my-custom-net my-running-container
```

To disconnect:
```bash
docker network disconnect my-custom-net my-running-container
```

---

## Lab Tasks

### Task 1: Attach container to network (`dkr-attach-container-network`)
1. Start the lab session:
   ```bash
   tld start dkr-attach-container-network
   ```
2. A running container named `isolated-app` and a custom network named `production-net` are available. Connect the container to the network:
   ```bash
   docker network connect production-net isolated-app
   ```
3. Verify that `isolated-app` is attached to `production-net`:
   ```bash
   docker inspect isolated-app --format '{{range $k, $v := .NetworkSettings.Networks}}{{$k}} {{end}}'
   ```
4. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Create a bridge network (`dkr-create-bridge-network`)
1. Start the lab session:
   ```bash
   tld start dkr-create-bridge-network
   ```
2. Create a user-defined bridge network named `custom-bridge-net`:
   ```bash
   docker network create --driver bridge custom-bridge-net
   ```
3. Verify the network driver and creation:
   ```bash
   docker network inspect custom-bridge-net --format '{{.Driver}}'
   ```
4. Validate your solution:
   ```bash
   tld check
   ```
