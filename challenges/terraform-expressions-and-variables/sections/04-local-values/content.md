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
