# Inspecting State

Instead of reading the raw JSON file `terraform.tfstate` directly, Terraform provides CLI commands to safely query current state:

## State Inspection Commands:
- `terraform state list`: Lists all tracked resources managed in the current state file.
- `terraform state show <RESOURCE>`: Prints detailed attributes of a single resource managed in state.

### Example:
```bash
$ terraform state list
local_file.app

$ terraform state show local_file.app
# local_file.app:
resource "local_file" "app" {
    content  = "production"
    filename = "/tmp/prod_1.txt"
    id       = "7e1f46b"
}
```
