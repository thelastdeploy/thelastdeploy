# Input Variables

Input variables serve as parameters for a Terraform module, allowing configurations to be customized without altering the source code.

## Variable Declaration Syntax
```hcl
variable "region" {
  type        = string
  description = "The AWS region to deploy resources into"
  default     = "us-east-1"
}
```

## Supported Types:
- Primitive types: `string`, `number`, `bool`
- Complex types: `list(<TYPE>)`, `set(<TYPE>)`, `map(<TYPE>)`, `object({...})`, `tuple([...])`
