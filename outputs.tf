output "ecs_cluster_id" {
  value = aws_ecs_cluster.ecs_cluster.id
}

output "ecs_asg_id" {
  value = aws_autoscaling_group.ecs_asg.id
}
