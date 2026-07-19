# Reading Terraform Errors

When Terraform encounters an issue, it prints structured error messages to standard output. Learning to read these messages quickly pinpoints the root cause.

## Anatomy of a Terraform Error Output:
```
│ Error: Invalid attribute name
│ 
│   on main.tf line 4, in resource "local_file" "example":
│    4:   invalid_param = "value"
│ 
│ An argument named "invalid_param" is not expected here.
```
- **Line 1 (Error Summary):** States the broad category of the problem (`Invalid attribute name`).
- **Line 3 (Location):** Pinpoints the file name (`main.tf`), line number (`line 4`), and block header.
- **Line 6 (Explanation):** Provides specific context on why the error occurred and how to fix it.

## Enabling Verbose Debug Logs:
Set the `TF_LOG` environment variable for detailed internal logging:
```bash
export TF_LOG=DEBUG
terraform plan
```
Supported log levels: `TRACE`, `DEBUG`, `INFO`, `WARN`, `ERROR`.
