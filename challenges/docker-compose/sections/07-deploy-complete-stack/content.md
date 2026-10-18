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

### Task 1: Deploy a complete blog platform (`dkr-deploy-blog-platform`)
1. Start the lab session:
   ```bash
   tld start dkr-deploy-blog-platform
   ```
2. Navigate to `~/docker-compose/blog-platform/`:
   ```bash
   cd "$HOME/docker-compose/blog-platform"
   ```
3. Create the `docker-compose.yml` file configuring WordPress and MySQL:
   ```yaml
   cat << 'EOF' > docker-compose.yml
   version: "3.8"

   services:
     wordpress:
       image: wordpress:latest
       networks:
         - blog-net
       ports:
         - "8083:80"
       volumes:
         - wp_data:/var/www/html
       environment:
         - WORDPRESS_DB_HOST=db
         - WORDPRESS_DB_USER=wordpress
         - WORDPRESS_DB_PASSWORD=wordpass
         - WORDPRESS_DB_NAME=wordpress

     db:
       image: mysql:8.0
       networks:
         - blog-net
       volumes:
         - db_data:/var/lib/mysql
       environment:
         - MYSQL_RANDOM_ROOT_PASSWORD=yes
         - MYSQL_USER=wordpress
         - MYSQL_PASSWORD=wordpass
         - MYSQL_DATABASE=wordpress

   networks:
     blog-net:

   volumes:
     wp_data:
     db_data:
   EOF
   ```
4. Start the stack in detached mode:
   ```bash
   docker compose up -d
   ```
5. Verify running services:
   ```bash
   docker compose ps
   ```
6. Validate your solution:
   ```bash
   tld check
   ```
