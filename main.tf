provider "aws" {
  region = "ap-south-1"
}

# 🔹 Create ECS Cluster
resource "aws_ecs_cluster" "nginx_cluster" {
  name = "nginx-ecs-cluster"
}

# 🔹 IAM Role for ECS Task Execution (Fixed Naming)
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole1"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = "sts:AssumeRole"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

# 🔹 Attach Required ECS Policies
resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# 🔹 Define ECS Task Definition for NGINX
resource "aws_ecs_task_definition" "nginx_task" {
  family                   = "nginx-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name      = "nginx-container"
      image     = "nginx:latest"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
    }
  ])
}

# 🔹 Create Security Group for ECS
resource "aws_security_group" "ecs_sg" {
  name_prefix = "ecs-sg-"
  vpc_id      = "vpc-052886a997da3e464"  # Replace with your VPC ID

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 🔹 Create an Application Load Balancer (ALB)
resource "aws_lb" "nginx_alb" {
  name               = "nginx-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ecs_sg.id]
  subnets            = ["subnet-01c77ed334a7370f5", "subnet-09f9df3a6be9b2791"]  # Replace with your subnet IDs
}

# 🔹 ALB Target Group
resource "aws_lb_target_group" "nginx_tg" {
  name        = "nginx-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = "vpc-052886a997da3e464"  # Replace with your VPC ID
  target_type = "ip"
}

# 🔹 ALB Listener (Explicit Dependency Fix)
resource "aws_lb_listener" "nginx_listener" {
  load_balancer_arn = aws_lb.nginx_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx_tg.arn
  }
}

# 🔹 Create ECS Service (Ensured Dependencies)
resource "aws_ecs_service" "nginx_service" {
  name            = "nginx-service"
  cluster         = aws_ecs_cluster.nginx_cluster.id
  task_definition = aws_ecs_task_definition.nginx_task.arn
  launch_type     = "FARGATE"
  desired_count   = 2

  network_configuration {
    subnets          = ["subnet-01c77ed334a7370f5", "subnet-09f9df3a6be9b2791"]  # Replace with your subnet IDs
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.nginx_tg.arn
    container_name   = "nginx-container"
    container_port   = 80
  }

  depends_on = [aws_lb_listener.nginx_listener]
}

# 🔹 Output ALB DNS Name & ECS Task Info
output "alb_dns" {
  description = "ALB DNS Name"
  value       = aws_lb.nginx_alb.dns_name
}

output "ecs_task_def" {
  description = "ECS Task Definition ARN"
  value       = aws_ecs_task_definition.nginx_task.arn
}
