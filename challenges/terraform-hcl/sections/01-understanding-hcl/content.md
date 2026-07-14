# Understanding HCL (HashiCorp Configuration Language)

HashiCorp Configuration Language (HCL) is a configuration language designed to build structured configuration files for HashiCorp tools, most notably Terraform.

## Why HCL?
HCL is designed to strike a balance between human readability and machine friendliness:
- **More readable than JSON/YAML:** It supports comments, indentation, and structure that make infrastructure code easy to scan.
- **Declarative Design:** HCL files describe the desired target state of infrastructure rather than a sequence of commands to execute.
- **Strongly Typed:** It supports structured data blocks, values, lists, maps, and expressions.
