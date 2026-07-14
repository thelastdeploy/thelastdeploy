# Validation and Linting

Before applying configurations, always validate them using built-in commands and linting utilities.

## 1. Validation (`terraform validate`)
This command verifies whether configurations are syntactically valid and internally consistent (e.g., checks arguments, types, and variables).
It requires the project to be initialized (`terraform init`) first.

## 2. Linting (`tflint`)
While validate checks syntax correctness, linting tools analyze best practices, warnings, potential errors, and deprecated providers.
