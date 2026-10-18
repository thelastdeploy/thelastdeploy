## Building Images

Once you have written a Dockerfile, you need to compile it into a runnable Docker image. This is done using the `docker build` command.

---

## 1. The Build Command Syntax

The general syntax to build an image is:
```bash
docker build -t <repository-name>:<tag> <path-to-build-context>
```
* **`-t` (Tag)**: Specifies the name and optionally a tag for the target image (e.g. `-t my-app:v1.0`). If no tag is specified, it defaults to `latest`.
* **Build Context**: The directory path containing the Dockerfile and any files you want to copy into the image. Commonly, you run the command in the same directory as the Dockerfile and use `.` to denote the current directory as the context.

For example, to build an image named `custom-service:1.0` using the current directory:
```bash
docker build -t custom-service:1.0 .
```

---

## Lab Tasks

### Task 1: Build a custom image (`dkr-build-custom-image`)
1. Start the lab session:
   ```bash
   tld start dkr-build-custom-image
   ```
2. Navigate to `~/docker-build/custom-app/` and build the image tagged as `my-custom-app:v1.0`:
   ```bash
   docker build -t my-custom-app:v1.0 "$HOME/docker-build/custom-app"
   ```
3. Verify that the image has been built and listed in local storage:
   ```bash
   docker images my-custom-app:v1.0
   ```
4. Validate your solution:
   ```bash
   tld check
   ```
