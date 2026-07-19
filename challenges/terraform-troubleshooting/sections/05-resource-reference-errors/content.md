# Resource Reference Errors

Reference errors occur when code tries to access a resource or attribute that does not exist.

## Typical Scenarios:
- **Typo in Resource Identifier:** Calling `local_file.my_file` when the block is named `resource "local_file" "myfile"`.
- **Referencing Non-Existent Attributes:** Trying to read `resource.id` when the provider names that field `resource.name`.
- **Undefined Variables:** Calling `var.env` without declaring `variable "env"` in `variables.tf`.
