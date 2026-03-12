# Enterprise-Grade AWS Architecture Using Terraform
### Automated Infrastructure with Terraform, Docker, and MySQL RDS

[![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)
[![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)

This repository showcases a professional-grade, highly available 3-tier architecture. It automates the deployment of a containerized WordPress application connected to a secure Amazon RDS backend, implementing industry best practices for security and scalability.

---

## Architecture Deep Dive

The infrastructure is built across two Availability Zones (AZs) for high availability:

* **Web Tier:** Application Load Balancer (ALB) receiving public HTTP traffic.
* **Application Tier:** Auto Scaling Group (ASG) managing EC2 instances in private subnets. Instances are automatically bootstrapped with Docker and WordPress via dynamic `templatefile` injection.
* **Database Tier:** Amazon RDS (MySQL 8.0) located in isolated "Secure" subnets.
* **Security:** * **VPC Endpoints (Interface):** Allows secure communication between private EC2s and AWS services (SSM) without using the public internet.
    * **Layered SGs:** Security groups are tiered so that the database only accepts traffic from the application layer.

---

## 📂 Project Structure

```text
.
├── main/
│   ├── main.tf              # Root configuration calling all modules
│   ├── variables.tf         # Root variables
│   ├── outputs.tf           # Root outputs (ALB DNS, etc.)
│   ├── statefile.tf         # Remote Backend (S3 + DynamoDB)
│   └── terraform.tfvars     # Environment-specific values
└── modules/
    ├── vpc/                 # Networking: VPC, Subnets, IGW
    ├── natgateway/          # Outbound connectivity for private subnets
    ├── alb/                 # Load Balancer & Target Groups
    ├── asg/                 # Launch Template, ASG, & Userdata script
    ├── rds/                 # MySQL Database & Subnet Groups
    └── ec2/                 # IAM Roles, Instance Profiles, & VPC Endpoints

```

---

## Step 1: Manual Backend Setup

Terraform requires an S3 bucket and DynamoDB table to exist *before* initialization.

**1. Create S3 Bucket:**

```bash
aws s3api create-bucket --bucket princes-tf-state-bucket-9988 --region ap-south-1 --create-bucket-configuration LocationConstraint=ap-south-1

```

**2. Create DynamoDB Table:**

```bash
aws dynamodb create-table --table-name vegeta-terraform-remote-state-table --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --billing-mode PAY_PER_REQUEST --region ap-south-1

```

---

## Step 2: Deployment

```bash
# Initialize & sync modules
terraform init -reconfigure

# Validate syntax
terraform plan

# Deploy infrastructure
terraform apply -auto-approve

```

---

## Troubleshooting & Verification

* **RDS Readiness:** RDS takes ~10 minutes to initialize. WordPress may show a "Connection Error" until the DB is fully `Available`.
* **Docker Status:** Log in via SSM to check container logs:
```bash
sudo docker ps
sudo docker logs <container_id>

```


* **Naming Constraints:** AWS ALBs do not allow underscores. Ensure `project_name` in `.tfvars` uses hyphens (e.g., `aws-tf-project`).

---

## Step 3: Cleanup (Manual Action Required)

To prevent costs, destroy the resources and then **manually** delete the backend:

1. `terraform destroy -auto-approve`
2. **Delete S3 Bucket:** `aws s3 rb s3://princes-tf-state-bucket-9988 --force`
3. **Delete Table:** `aws dynamodb delete-table --table-name vegeta-terraform-remote-state-table --region ap-south-1`

---

##  Connect with Me

**Prince Singh Chauhan**

 **Portfolio:** https://princesinghchauhan.qzz.io
 **LinkedIn:** https://linkedin.com/in/your-profile
 **GitHub:** https://github.com/ONEPRINCEISREAL



