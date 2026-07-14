# Expressions

Expressions allow you to dynamically compute values inside HCL configurations.

## String Interpolation
You can embed variables or expressions in double-quoted strings using the `${}` syntax:
```hcl
variable "name" {
  default = "DevOps"
}

resource "local_file" "welcome" {
  content  = "Welcome to ${var.name} track!"
  filename = "/tmp/welcome.txt"
}
```

## Basic Mathematical & Logical Expressions
HCL supports standard mathematical operators (`+`, `-`, `*`, `/`) and logical operators (`&&`, `||`, `!`).
