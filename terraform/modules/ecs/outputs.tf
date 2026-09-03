output "ecs_security_group_id" {
  value = aws_security_group.service_security_group.id
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.ecs_workshop.name
}

output "ecs_task_execution_role_arn" {
  value = aws_iam_role.ecsTaskExecutionRole.arn
}