# Variable Files

To assign values to variables, you can use `.tfvars` files, environment variables, or CLI arguments.

## Loading Order and Precedence:
Terraform loads variables in the following order (last loaded wins):
1. Environment variables (`TF_VAR_variable_name`)
2. The `terraform.tfvars` file
3. The `terraform.tfvars.json` file
4. Any `*.auto.tfvars` files
5. `-var` and `-var-file` options on the command line

## Syntax of terraform.tfvars:
```hcl
filename = "/tmp/my_file.txt"
content  = "Hello World"
```
