# Blocks and Arguments

HCL configurations consist of two primary concepts: **Blocks** and **Arguments**.

## 1. Blocks
Blocks act as containers for configuration details. They have a type, optional labels, and a body enclosed in curly braces:
```hcl
block_type "label_one" "label_two" {
  # Block body containing arguments
}
```
Example of a `resource` block:
- Block type: `resource`
- First label (Resource Type): `local_file`
- Second label (Resource Name): `welcome`

## 2. Arguments
Arguments assign a value to an identifier (name). They are set using the `=` sign:
```hcl
key = value
```
Example:
```hcl
filename = "/tmp/welcome.txt"
```
