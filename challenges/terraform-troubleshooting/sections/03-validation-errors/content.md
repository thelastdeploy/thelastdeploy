# Validation Errors

Validation errors happen when HCL syntax is valid, but the arguments provided to resources, modules, or variables violate schema constraints.

## Common Causes:
1. **Invalid Attribute Names:** Specifying an argument that the resource type does not accept.
2. **Type Mismatch:** Passing a string where a number or list is expected.
3. **Missing Required Arguments:** Omitting mandatory parameters (e.g., leaving out `filename` on `local_file`).

Run `terraform validate` after `terraform init` to catch schema errors before planning.
