## Inspecting Storage

When containers are running with complex storage configurations, you need to verify where and how volumes are mounted. You can find this information by inspecting the container's metadata.

---

## 1. Finding Mount Information (`docker inspect`)

To find mount configurations, inspect the container and look at the `Mounts` section in the JSON output:
```bash
docker inspect <container-name>
```

You can extract the mounts directly using a Go template format:
```bash
docker inspect -f '{{json .Mounts}}' <container-name>
```

The output contains key fields for each mount:
* **`Type`**: Indicates if it is a `bind` mount or a `volume` mount.
* **`Source`**: The path on the host system where the data is stored.
* **`Destination`**: The path inside the container where the host path is mounted.

---

## Lab Tasks

### Task 1: Find volume usage (`dkr-find-volume-usage`)
1. Start the lab session:
   ```bash
   tld start dkr-find-volume-usage
   ```
2. A background container named `analytics-app` is already running with a named volume `analytics-vol` mounted to a specific directory inside the container.
3. Inspect the container to locate the destination mount path of `analytics-vol` and save it to `~/docker-test/volume_destination.txt`:
   ```bash
   mkdir -p "$HOME/docker-test"
   docker inspect --format '{{range .Mounts}}{{if eq .Name "analytics-vol"}}{{.Destination}}{{end}}{{end}}' analytics-app > "$HOME/docker-test/volume_destination.txt"
   ```
4. Verify the saved destination path:
   ```bash
   cat "$HOME/docker-test/volume_destination.txt"
   ```
5. Validate your solution:
   ```bash
   tld check
   ```
