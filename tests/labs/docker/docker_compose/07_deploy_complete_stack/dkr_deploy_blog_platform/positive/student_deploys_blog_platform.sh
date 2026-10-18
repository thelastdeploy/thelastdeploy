#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Deploys Complete Blog Platform
# Lab: dkr-deploy-blog-platform
# ==============================================================================

# Step 1: Ensure directory exists
student_exec \
  --step-name "Ensure directory exists" \
  --cmd "mkdir -p ~/docker-compose/blog-platform" \
  --expect-exit-code 0

# Step 2: Write complete docker-compose.yml
student_exec \
  --step-name "Write docker-compose.yml" \
  --cmd "cat << 'EOF' > ~/docker-compose/blog-platform/docker-compose.yml
version: \"3.8\"

services:
  wordpress:
    image: wordpress:latest
    networks:
      - blog-net
    ports:
      - \"8083:80\"
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
EOF" \
  --expect-exit-code 0

# Step 3: Start compose stack in detached mode
student_exec \
  --step-name "Launch compose stack in detached mode" \
  --cmd "docker compose -f ~/docker-compose/blog-platform/docker-compose.yml up -d" \
  --expect-exit-code 0

# Step 4: Verify compose stack is running
student_exec \
  --step-name "Verify compose stack status" \
  --cmd "docker compose -f ~/docker-compose/blog-platform/docker-compose.yml ps" \
  --expect-exit-code 0 \
  --expect-stdout-contains "wordpress"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Successfully deployed WordPress + MySQL blog stack with networking and volumes."
