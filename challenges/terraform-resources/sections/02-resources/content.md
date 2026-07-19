# Resources

Resources are the most important block type in Terraform. They describe one or more infrastructure objects, such as virtual networks, compute instances, or local files.

## Resource Block Syntax
```hcl
resource "provider_resource-type" "local-name" {
  argument1 = value1
  argument2 = value2
}
```
- **Resource Type (`local_file`)**: Denotes the type of infrastructure to manage. It always starts with the provider prefix.
- **Resource Name (`welcome`)**: An internal label to represent this resource within the current Terraform module.
