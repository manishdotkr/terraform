# Terraform Learning Journey

## Overview

Welcome! This repository is part of my journey to learn Terraform, a tool for building, changing, and versioning infrastructure safely and efficiently. 

## First Step: Creating an EC2 Machine

As the first step in my learning process, I am focusing on creating an EC2 (Elastic Compute Cloud) instance on AWS. This is a foundational exercise aimed at understanding the basics of Terraform, including:

- Writing basic Terraform configuration files.
- Understanding providers, resources, and variables.
- Deploying infrastructure on AWS using Terraform.

## What’s Next?

After successfully creating and managing an EC2 instance, I plan to explore more advanced features of Terraform, such as:

- Managing multiple resources.
- Using modules for reusable configurations.
- Implementing Terraform state management.

## Getting Started

If you’re interested in following along or running the code yourself:

1. **Install Terraform**: [Terraform Installation Guide](https://learn.hashicorp.com/tutorials/terraform/install-cli)
2. **Configure AWS CLI**: [AWS CLI Installation Guide](https://aws.amazon.com/cli/)
3. **Clone the Repository**: 
   ```bash
   git clone https://github.com/yourusername/your-repo.git
   ```
4. **Create a `terraform.tfvars` File**:
   Create a `terraform.tfvars` file to store your AWS credentials securely:
   ```hcl
   aws_access_key = "your-access-key"
   aws_secret_key = "your-secret-key"
   ```
   **Note**: Never commit this file to your repository. Add it to `.gitignore`.

5. **Initialize Terraform**:
   ```bash
   terraform init
   ```
6. **Create a Plan**:
   ```bash
   terraform plan -out=tfplan -var-file="aws_cred.tfvars"
   ```
   This command creates an execution plan and saves it to a file named `tfplan`. This allows you to review the changes Terraform will make before applying them.

7. **Apply the Plan**:
   ```bash
   terraform apply tfplan
   ```
   This command applies the changes specified in the `tfplan` file, creating the EC2 instance on AWS.

8. **USe Variables**:
   If you want to clean up and destroy all resources created by Terraform, use:
   ```bash
   terraform apply tfplan -var-file="aws_cred.tfvars"
   ```
   This will remove all infrastructure defined in your Terraform configuration.

9. **Destroy the Infrastructure**:
   If you want to clean up and destroy all resources created by Terraform, use:
   ```bash
   terraform destroy -var-file="aws_cred.tfvars"
   ```
   This will remove all infrastructure defined in your Terraform configuration.


