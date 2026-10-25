# Local Values

A local value assigns a name to an expression, allowing you to reuse the expression multiple times throughout a module without repeating it (DRY principle).

## Syntax:
```hcl
locals {
  service_name = "payment-api"
  environment  = "production"
  common_tags = {
    Service     = local.service_name
    Environment = local.environment
  }
}
```

Locals are referenced using `local.local_name`.

---

## Lab Tasks

### Task 1: Use Local Values for DRY Code
1. Start the lab in your terminal:
   ```bash
   tld start tf-use-locals
   ```
2. Navigate to `~/terraform-expr-challenge`:
   ```bash
   cd ~/terraform-expr-challenge
   ```
3. Open `main.tf`, define a `locals` block, and update `local_file.f1` to reference `local.env`:
   ```hcl
   locals {
     env = "production"
   }

   resource "local_file" "f1" {
     content  = local.env
     filename = "/tmp/prod_1.txt"
   }
   ```
4. Verify the task:
   ```bash
   tld check
   ```
