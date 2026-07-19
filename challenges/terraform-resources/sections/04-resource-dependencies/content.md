# Resource Dependencies

Often, one resource depends on another. Terraform supports two types of dependencies:

## 1. Implicit Dependencies
Formed when a resource references an attribute of another resource. Terraform automatically analyzes these references and builds them in the correct sequence.
```hcl
resource "random_id" "server" {
  byte_length = 8
}

resource "local_file" "config" {
  content  = "Server ID: ${random_id.server.hex}"
  filename = "/tmp/server_config.txt"
}
```

## 2. Explicit Dependencies
Used when resources have dependency relationships that are not visible via code references. You configure these using the `depends_on` meta-argument:
```hcl
resource "local_file" "db" {
  content  = "database"
  filename = "/tmp/db.txt"
}

resource "local_file" "app" {
  content    = "app"
  filename   = "/tmp/app.txt"
  depends_on = [local_file.db]
}
```
