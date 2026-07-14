# Project Structure

As Terraform projects grow, storing all configurations in a single `main.tf` file becomes difficult to manage. Standard practices split files into logical scopes:

- **`providers.tf`**: Configures provider blocks and plugin requirements.
- **`variables.tf`**: Declares variable inputs to customize configuration behavior dynamically.
- **`outputs.tf`**: Declares output variables showing resource information after provisioning.
- **`main.tf`**: Houses the actual resource definitions.

Terraform loads all `.tf` files in the working directory and merges them. The filenames themselves do not change how code runs, but they serve as a critical layout standard.
