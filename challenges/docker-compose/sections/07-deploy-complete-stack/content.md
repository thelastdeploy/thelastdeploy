## Deploy a Complete Stack

In this final section, you will synthesize all the concepts you have learned so far—services, custom bridge networks, volumes for persistent storage, and environment variables—to deploy a fully functional WordPress and MySQL database stack.

---

### Best Practices to Apply

When designing a production-grade compose configuration:
1. **Network Isolation**: Ensure only necessary services are exposed to the internet. Internal databases should stay on isolated networks.
2. **Persistent Storage**: Ensure databases or dynamic uploads utilize named volumes or host bind mounts to prevent data loss.
3. **Environment Injection**: Decouple connection keys and passwords from the compose YAML file.

---

## Lab Tasks

### Task 1: Deploy a complete blog platform
1. Start the task:
   ```bash
   tld start dkr-deploy-blog-platform
   ```
2. Navigate to `~/docker-compose/blog-platform/`.
3. Create a `docker-compose.yml` that implements the following stack requirements:
   - **Networks**:
     - A custom bridge network named `blog-net`.
   - **Volumes**:
     - A named volume called `wp_data`.
     - A named volume called `db_data`.
   - **Services**:
     - `wordpress`:
       - Use the `wordpress:latest` image.
       - Connect it only to the `blog-net` network.
       - Expose host port `8083` mapped to container port `80`.
       - Mount the `wp_data` volume inside the container at `/var/www/html`.
       - Configure the environment variables to connect to the database:
         - `WORDPRESS_DB_HOST=db` (resolving the database service name)
         - `WORDPRESS_DB_USER=wordpress`
         - `WORDPRESS_DB_PASSWORD=wordpass`
         - `WORDPRESS_DB_NAME=wordpress`
     - `db`:
       - Use the `mysql:8.0` image.
       - Connect it only to the `blog-net` network.
       - Mount the `db_data` volume inside the container at `/var/lib/mysql`.
       - Configure the environment variables:
         - `MYSQL_RANDOM_ROOT_PASSWORD=yes`
         - `MYSQL_USER=wordpress`
         - `MYSQL_PASSWORD=wordpass`
         - `MYSQL_DATABASE=wordpress`
4. Deploy the stack in detached mode (`docker compose up -d`).
5. Run the validator:
   ```bash
   tld check
   ```
