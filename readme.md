# 🚀 AWS ECS Fargate Deployment with Terraform (NGINX)

This project automates the deployment of an **NGINX container** on **AWS ECS Fargate** using **Terraform**. It provisions an ECS cluster, task definition, IAM roles, security groups, and an Application Load Balancer (ALB) to expose the service.

## 📌 Features
- **ECS Fargate Cluster**: Serverless container orchestration.
- **NGINX Task Definition**: Runs a lightweight NGINX container.
- **Application Load Balancer (ALB)**: Distributes traffic across ECS tasks.
- **IAM Role & Security Group**: Secure execution and networking setup.
- **Terraform Infrastructure as Code (IaC)**: Automates provisioning.

## 🛠️ Prerequisites
Before deploying, ensure you have:
- **AWS CLI** installed & configured (`aws configure`).
- **Terraform v1.x** installed (`terraform -v`).
- **Access to an AWS Account** with IAM permissions.
- **VPC & Subnet IDs** where the ECS service will be deployed.

## 🚀 Deployment Steps

### 1️⃣ Clone the Repository
```sh
https://github.com/harshal1996sahadeokar/ECS_with_terraform.git

