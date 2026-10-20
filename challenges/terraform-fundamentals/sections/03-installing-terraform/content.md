# Installing Terraform

To work with Terraform, you need to install the Terraform Command Line Interface (CLI) on your machine. The CLI is a single compiled binary package that interfaces with various cloud providers and systems.

## Installation Methods:

### Standalone Binary Installation (Linux):
```bash
curl -fsSL https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip -o /tmp/terraform.zip
sudo unzip -o /tmp/terraform.zip -d /usr/local/bin
sudo chmod +x /usr/local/bin/terraform
rm -f /tmp/terraform.zip
```

### On Ubuntu/Debian Linux (via APT):
```bash
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com noble main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update && sudo apt-get install -y terraform
```

### On macOS (using Homebrew):
```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

### Verifying Installation:
Once installed, verify that the CLI is accessible by running:
```bash
terraform -version
```

---

## Lab Tasks

### Task 1: Verify Terraform Version
1. Start the lab in your terminal:
   ```bash
   tld start tf-check-version
   ```
2. Verify that the Terraform CLI executable is operational by running:
   ```bash
   terraform -version
   ```
3. Verify the task:
   ```bash
   tld check
   ```

### Task 2: Install Terraform CLI
1. Start the lab in your terminal:
   ```bash
   tld start tf-install-cli
   ```
2. Ensure that the `terraform` executable is present in your system `PATH`:
   ```bash
   which terraform || (curl -fsSL https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip -o /tmp/tf.zip && sudo unzip -qo /tmp/tf.zip -d /usr/local/bin && rm -f /tmp/tf.zip)
   which terraform
   ```
3. Verify the task:
   ```bash
   tld check
   ```
