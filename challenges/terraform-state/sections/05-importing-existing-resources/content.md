# Importing Existing Resources

If you have pre-existing infrastructure created manually, you can bring it under Terraform management using `terraform import`.

## Import Syntax:
```bash
terraform import <RESOURCE_TYPE>.<RESOURCE_NAME> <RESOURCE_ID>
```

### Example:
```bash
terraform import local_file.existing /tmp/existing.txt
```
After running import, write the matching `resource "local_file" "existing"` block in your code to complete adoption.
