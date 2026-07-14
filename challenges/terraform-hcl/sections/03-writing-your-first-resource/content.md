# Writing Your First Resource

To write a resource in HCL, you define a `resource` block containing the type of resource you want to create, its local identifier, and configuration arguments.

## Resource Syntax:
```hcl
resource "local_file" "welcome" {
  content  = "Welcome to The Last Deploy!"
  filename = "/tmp/welcome.txt"
}
```
- `"local_file"`: Tells Terraform which provider plugin is responsible for this resource.
- `"welcome"`: The internal name used to reference this resource elsewhere in the code.
- `content` and `filename`: Configuration arguments specific to the `local_file` resource type.
