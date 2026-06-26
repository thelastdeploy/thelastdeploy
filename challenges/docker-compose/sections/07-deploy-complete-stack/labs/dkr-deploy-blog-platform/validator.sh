#!/bin/bash
# validator.sh — docker-compose / 07-deploy-complete-stack / dkr-deploy-blog-platform
set -euo pipefail

# 1. Get container IDs
WP_CID=$(docker ps --filter "label=com.docker.compose.project=blog-platform" --filter "label=com.docker.compose.service=wordpress" --filter "status=running" -q)
DB_CID=$(docker ps --filter "label=com.docker.compose.project=blog-platform" --filter "label=com.docker.compose.service=db" --filter "status=running" -q)

if [ -z "$WP_CID" ] || [ -z "$DB_CID" ]; then
  echo "FAIL: Make sure 'wordpress' and 'db' services are running."
  exit 1
fi

# 2. Check port mapping for wordpress
WP_PORT=$(docker inspect "$WP_CID" --format '{{(index (index .NetworkSettings.Ports "80/tcp") 0).HostPort}}' 2>/dev/null || echo "")
if [ "$WP_PORT" != "8083" ]; then
  echo "FAIL: Service 'wordpress' is not mapped to host port 8083. Got: '$WP_PORT'"
  exit 1
fi

# 3. Check custom network
WP_NETS=$(docker inspect "$WP_CID" --format '{{range $k, $v := .NetworkSettings.Networks}}{{$k}} {{end}}')
DB_NETS=$(docker inspect "$DB_CID" --format '{{range $k, $v := .NetworkSettings.Networks}}{{$k}} {{end}}')

if [[ "$WP_NETS" != *"blog-net"* && "$WP_NETS" != *"blog_net"* ]]; then
  echo "FAIL: WordPress container is not connected to custom network 'blog-net'."
  exit 1
fi

if [[ "$DB_NETS" != *"blog-net"* && "$DB_NETS" != *"blog_net"* ]]; then
  echo "FAIL: Database container is not connected to custom network 'blog-net'."
  exit 1
fi

# 4. Check wordpress env variables
WP_ENV=$(docker inspect "$WP_CID" --format '{{range .Config.Env}}{{.}}
{{end}}')

if ! echo "$WP_ENV" | grep -q "WORDPRESS_DB_USER=wordpress"; then
  echo "FAIL: WordPress database user is not set to 'wordpress'."
  exit 1
fi
if ! echo "$WP_ENV" | grep -q "WORDPRESS_DB_PASSWORD=wordpass"; then
  echo "FAIL: WordPress database password is not set to 'wordpass'."
  exit 1
fi
if ! echo "$WP_ENV" | grep -q "WORDPRESS_DB_NAME=wordpress"; then
  echo "FAIL: WordPress database name is not set to 'wordpress'."
  exit 1
fi

# 5. Check db env variables
DB_ENV=$(docker inspect "$DB_CID" --format '{{range .Config.Env}}{{.}}
{{end}}')

if ! echo "$DB_ENV" | grep -q "MYSQL_USER=wordpress"; then
  echo "FAIL: Database MYSQL_USER is not set to 'wordpress'."
  exit 1
fi
if ! echo "$DB_ENV" | grep -q "MYSQL_PASSWORD=wordpass"; then
  echo "FAIL: Database MYSQL_PASSWORD is not set to 'wordpass'."
  exit 1
fi
if ! echo "$DB_ENV" | grep -q "MYSQL_DATABASE=wordpress"; then
  echo "FAIL: Database MYSQL_DATABASE is not set to 'wordpress'."
  exit 1
fi

# 6. Check wordpress volume mount
WP_MOUNTS=$(docker inspect "$WP_CID" --format '{{range .Mounts}}{{.Type}} {{.Destination}} {{.Name}}
{{end}}')
if ! echo "$WP_MOUNTS" | grep -qE "volume /var/www/html (.*_wp_data|wp_data)"; then
  echo "FAIL: WordPress volume 'wp_data' is not mounted correctly to '/var/www/html'."
  exit 1
fi

# 7. Check db volume mount
DB_MOUNTS=$(docker inspect "$DB_CID" --format '{{range .Mounts}}{{.Type}} {{.Destination}} {{.Name}}
{{end}}')
if ! echo "$DB_MOUNTS" | grep -qE "volume /var/lib/mysql (.*_db_data|db_data)"; then
  echo "FAIL: Database volume 'db_data' is not mounted correctly to '/var/lib/mysql'."
  exit 1
fi

echo "PASS: Successfully deployed WordPress + MySQL blog stack with networking and volumes."
exit 0
