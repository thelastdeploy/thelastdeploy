# Creating Your First Module

A child module is simply a directory containing Terraform `.tf` files.

## Calling a Child Module:
From your root module, invoke a child module using a `module` block and specify the `source` argument:
```hcl
module "file_writer" {
  source = "./modules/file_writer"
}
```

When you add or modify a `module` block, always run `terraform init` to let Terraform register the module source.
