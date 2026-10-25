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

---

## Lab Tasks

### Task 1: Pass Input Arguments to a Module
1. Start the lab in your terminal:
   ```bash
   tld start tf-module-inputs
   ```
2. Navigate to `~/terraform-modules-challenge`:
   ```bash
   cd ~/terraform-modules-challenge
   ```
3. Open `main.tf` and pass the `text` input argument to the `module "writer"` block:
   ```hcl
   module "writer" {
     source = "./modules/file_writer"
     text   = "Hello from root module"
   }
   ```
4. Verify the task:
   ```bash
   tld check
   ```

### Task 2: Access Output Values from a Module
1. Start the lab in your terminal:
   ```bash
   tld start tf-module-outputs
   ```
2. Navigate to `~/terraform-modules-challenge`:
   ```bash
   cd ~/terraform-modules-challenge
   ```
3. Open `main.tf` and add an output block referencing the module output `module.writer.file_path`:
   ```hcl
   output "written_file" {
     value = module.writer.file_path
   }
   ```
4. Verify the task:
   ```bash
   tld check
   ```
