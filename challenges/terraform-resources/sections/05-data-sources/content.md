# Data Sources

Data sources allow Terraform to fetch data defined outside of Terraform, or read by another separate Terraform configuration.

## Syntax
Unlike resources, data sources are declared using a `data` block:
```hcl
data "local_file" "external" {
  filename = "/tmp/external.txt"
}

resource "local_file" "copy" {
  content  = data.local_file.external.content
  filename = "/tmp/copy.txt"
}
```
