# 🔹 Output ALB DNS Name & ECS Task Info
output "alb_dns" {
  description = "ALB DNS Name"
  value       = aws_lb.nginx_alb.dns_name
}

output "ecs_task_def" {
  description = "ECS Task Definition ARN"
  value       = aws_ecs_task_definition.nginx_task.arn
}

