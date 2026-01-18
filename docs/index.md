````markdown
# DevOps Bootcamp Project

This repository contains the Terraform and Ansible setup for deploying a web application with monitoring on AWS.

## How to Run

### 1. Bootstrap Terraform Remote State

Provision the S3 backend **first**.

```bash
cd terraform/backend-bootstrap
terraform init
terraform apply
```
````

Proceed only after the S3 backend is created successfully.

---

### 2. Provision Infrastructure

Deploy VPC, EC2 instances, networking, and security groups.

```bash
cd ../main
terraform init
terraform apply
```

After apply completes, Terraform outputs SSM access commands:

```hcl
terraform output

ssm_commands = {
  "controller"  = "aws ssm start-session --target i-012a2546be7166d52"
  "monitoring"  = "aws ssm start-session --target i-06ef6ea6a35a9888a"
  "web_server"  = "aws ssm start-session --target i-0824e423ded17ad45"
}
```

---

### 3. Access Ansible Controller

SSM into the controller instance:

```bash
aws ssm start-session --target <controller-instance-id>
```

Wait for cloud-init to finish provisioning:

```bash
cloud-init status --wait
```

---

### 4. Run Ansible

From the controller:

```bash
cd ~/ansible
ansible-playbook run-all.yml
```

This:

- Installs Docker on all required servers
- Deploys the web application container
- Deploys Prometheus and Grafana
- Configures monitoring for CPU, RAM, and Disk

---

## Access

- **Web App**: `web.0xaiman.com`
- **Grafana**: `monitoring.0xaiman.com` (via Cloudflare Tunnel only)
- **SSM** enabled on all servers

---

## Notes

- ECR and GitHub Actions were **not implemented**
- Monitoring server is not publicly exposed
- All configuration is executed from the Ansible controller

Here’s a more **compact and concise version** of your `README.md`, keeping only the essential details:

## Repository Structure

```

devops-bootcamp-project/
├── terraform/ # AWS infrastructure code
├── ansible/ # Playbooks for app and monitoring
└── README.md

```

## Infrastructure (Terraform)

- **VPC**: `devops-vpc` (10.0.0.0/24) with public/private subnets
- **Security Groups**: `devops-public-sg` (web), `devops-private-sg` (controller & monitoring)
- **EC2 Instances**:
  - Web: 10.0.0.5 (public)
  - Ansible Controller: 10.0.0.135 (private)
  - Monitoring: 10.0.0.136 (private, Cloudflare Tunnel)
- **Terraform state** stored in S3: `devops-bootcamp-terraform-yourname`

> ECR and GitHub Actions were not implemented.

## Application & Monitoring (Ansible)

- Deploy `my-devops-project` Docker container on web server
- Monitoring server runs Prometheus + Grafana
- Metrics collected: CPU, RAM, Disk
- Grafana accessible via Cloudflare Tunnel only

## Access

- SSM enabled on all servers
- Ansible uses SSH from controller

## Domain & Cloudflare

- `web.0xaiman.com` → Web server
- `monitoring.0xaiman.com` → Grafana (via tunnel)

```

```
