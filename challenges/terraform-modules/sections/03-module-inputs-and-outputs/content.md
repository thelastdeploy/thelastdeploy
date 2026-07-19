# Module Inputs and Outputs

Modules interact with the root module using input variables and output values.

## Passing Inputs:
Inside a child module, declare variables in `variables.tf`. When invoking the module, pass values as block arguments:
```hcl
module "storage" {
  source    = "./modules/storage"
  file_text = "Custom content"
}
```

## Reading Outputs:
Child modules expose outputs declared in `outputs.tf`. The root module references child outputs using `module.<MODULE_NAME>.<OUTPUT_NAME>`:
```hcl
resource "local_file" "summary" {
  content  = "Storage file path is ${module.storage.file_path}"
  filename = "/tmp/summary.txt"
}
```
