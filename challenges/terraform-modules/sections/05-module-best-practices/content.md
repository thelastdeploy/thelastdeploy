# Module Best Practices

1. **Standard File Structure:** Every module should include `main.tf`, `variables.tf`, `outputs.tf`, and a `README.md`.
2. **Avoid Hardcoded Values:** Always expose configurable parameters via input variables with reasonable default values.
3. **Limit Provider Configurations:** Avoid defining `provider` blocks inside child modules; inherit providers from the root module instead.
4. **Version Module Sources:** When pulling modules from Git or the Terraform Registry, always pin explicit versions:
   ```hcl
   module "vpc" {
     source  = "terraform-aws-modules/vpc/aws"
     version = "5.1.0"
   }
   ```
