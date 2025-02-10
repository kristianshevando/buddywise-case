# Terraform Deployment Guide

## **Overview**
This directory contains Terraform code for deploying infrastructure, which consists of three components:
1. **1_mgmt** – Management resources
2. **2_sql** – Database resources
3. **3_core** – Core services

Currently, there is no pipeline to automatically deploy this code, so deployment must be done **locally** in a **specific order**.

---

## **Requirements**
Before running Terraform, ensure the following tools are installed:
- [Terraform](https://developer.hashicorp.com/terraform/downloads) (v1.8.5+)
- Azure account with appropriate permissions

---

## **1. Fill in tfvars file for each component**
Before executing Terraform, please make sure you set following variables in 1_mgmt/mgmt.auto.tfvars, 2_sql/sql.auto.tfvars and 3_core/core.auto.tfvars:

```sh
SUBSCRIPTION_ID   = "<placeholder>"
SPN_CLIENT_ID     = "<placeholder>"
SPN_CLIENT_SECRET = "<placeholder>"
TENANT_ID         = "<placeholder>"
```

---

## **2. Deploying Terraform Code**
Terraform components must be deployed **in sequence** because `core` and `sql` depend on `mgmt`.

### **Step 1: Deploy mgmt**
```sh
cd 1_mgmt
terraform init
terraform apply -auto-approve
cd ..
```
This step sets up foundational infrastructure, such as resource groups and IAM policies.

---

### **Step 2: Deploy sql**
Once `mgmt` is successfully deployed, proceed with `sql`:
```sh
cd 2_sql
terraform init
terraform apply -auto-approve
cd ..
```
This step provisions database-related resources.

---

### **Step 3: Deploy core**
Finally, deploy the main services:
```sh
cd 3_core
terraform init
terraform apply -auto-approve
cd ..
```
This step creates essential workloads and application resources.

---

## **3. Destroying Infrastructure**
To remove all deployed resources, execute the following commands in **reverse order**:
```sh
cd 3_core
terraform destroy -auto-approve
cd ../2_sql
terraform destroy -auto-approve
cd ../1_mgmt
terraform destroy -auto-approve
cd ..
```
Destroying components in the correct order ensures dependency management.

---

## **5. Additional Information**
- Modules are stored in [`modules/`](./modules/)
- Global configurations are in [`4_common/`](./4_common/)
- Configuration values can be modified in `*.auto.tfvars` files

---

### 🚀 **Your infrastructure is now ready for deployment and testing!**

