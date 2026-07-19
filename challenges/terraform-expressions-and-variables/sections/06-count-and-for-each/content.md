# Count and For Each

When you need to create multiple similar resources, use `count` or `for_each`.

## 1. `count` Meta-Argument
Creates a specific number of instances based on an integer value:
```hcl
resource "local_file" "servers" {
  count    = 3
  content  = "Server number ${count.index}"
  filename = "/tmp/server_${count.index}.txt"
}
```

## 2. `for_each` Meta-Argument
Creates instances according to a set or map of keys:
```hcl
resource "local_file" "files" {
  for_each = toset(["app", "db", "cache"])
  content  = "Config for ${each.key}"
  filename = "/tmp/${each.key}.conf"
}
```
