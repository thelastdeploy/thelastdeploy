## Build Custom Web Server

Docker makes it extremely simple to bundle application code or static assets (like HTML, CSS, JS files) directly inside a web server image so it is fully self-contained.

---

## 1. Extending Nginx Base Image

Rather than configuring Nginx from scratch, you can use the official `nginx` image as your base and copy your custom configuration or static files into it.

The official Nginx image serves files from `/usr/share/nginx/html/` by default. 

---

## 2. Using the `COPY` Instruction

In your Dockerfile, you can use the `COPY` instruction to copy your local `index.html` file into the container's Nginx web root directory:
```dockerfile
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
```

When you build and run this container, Nginx will automatically serve your custom HTML page instead of the default Nginx welcome page.

---

## Lab Tasks

### Task 1: Build a custom Nginx site (`dkr-build-custom-nginx-site`)
1. Start the lab session:
   ```bash
   tld start dkr-build-custom-nginx-site
   ```
2. Navigate to `~/docker-build/nginx-custom/` and author the `Dockerfile`:
   ```bash
   mkdir -p "$HOME/docker-build/nginx-custom"
   cat << 'EOF' > "$HOME/docker-build/nginx-custom/Dockerfile"
   FROM nginx:alpine
   COPY index.html /usr/share/nginx/html/index.html
   EOF
   ```
3. Build the Docker image tagged as `my-nginx-web:latest`:
   ```bash
   docker build -t my-nginx-web:latest "$HOME/docker-build/nginx-custom"
   ```
4. Verify that the image has been built and listed in local storage:
   ```bash
   docker images my-nginx-web:latest
   ```
5. Validate your solution:
   ```bash
   tld check
   ```
