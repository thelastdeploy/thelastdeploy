## Inspecting Images

Docker images contain detailed metadata about how they were built, what environment variables they define, their entrypoints, default commands, and hardware architecture. You can inspect this metadata using `docker image inspect`.

---

## 1. Inspecting Image Metadata (`docker image inspect`)

To view the raw JSON metadata of an image, run:
```bash
docker image inspect alpine:3.18.5
```
This returns a large JSON array containing configuration details.

---

## 2. Filtering Metadata using `--format`

Since the JSON output is very long, you can use Go template syntax with the `-f` or `--format` flag to extract specific fields directly.

For example, to find the image's author or architecture:
```bash
docker image inspect -f '{{.Architecture}}' alpine:3.18.5
```
Or to inspect the default command:
```bash
docker image inspect -f '{{.Config.Cmd}}' nginx:alpine
```

---

## Lab Tasks

### Task 1: Find image metadata (`dkr-find-image-metadata`)
1. Start the lab session:
   ```bash
   tld start dkr-find-image-metadata
   ```
2. The image `alpine:3.18.5` is pre-pulled on your system. Extract its Architecture metadata:
   ```bash
   docker image inspect -f '{{.Architecture}}' alpine:3.18.5
   ```
3. Create the test output directory and save the architecture into `~/docker-test/image_arch.txt`:
   ```bash
   mkdir -p "$HOME/docker-test"
   docker image inspect -f '{{.Architecture}}' alpine:3.18.5 > "$HOME/docker-test/image_arch.txt"
   ```
4. Verify file contents:
   ```bash
   cat "$HOME/docker-test/image_arch.txt"
   ```
5. Validate your solution:
   ```bash
   tld check
   ```
