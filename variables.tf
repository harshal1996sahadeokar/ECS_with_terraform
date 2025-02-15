variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "ecs_cluster_name" {
  description = "ECS Cluster Name"
  type        = string
  default     = "ecs-ec2-cluster"
}

variable "ami_id" {
  description = "Amazon ECS-optimized AMI ID"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for ECS hosts"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "SSH key name"
  type        = string
}

variable "desired_capacity" {
  description = "Desired number of ECS instances"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of ECS instances"
  type        = number
  default     = 3
}

variable "min_size" {
  description = "Minimum number of ECS instances"
  type        = number
  default     = 1
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}
