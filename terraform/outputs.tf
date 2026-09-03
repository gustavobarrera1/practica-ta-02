output "alb_target_group_arn" {
  value = module.alb.lb_target_group_arn
}

output "alb_sg_lb_id" {
  value = module.alb.sg_lb_id
}

output "ecr_ecr_url" {
  value = module.ecr.ecr_url
}

output "ecs_ecs_security_group_id" {
  value = module.ecs.ecs_security_group_id
}

output "ecs_ecs_cluster_name" {
  value = module.ecs.ecs_cluster_name
}

output "ecs_ecs_task_execution_role_arn" {
  value = module.ecs.ecs_task_execution_role_arn
}

output "vpc_default_vpc_id" {
  value = module.vpc.default_vpc_id
}

output "vpc_subnet_a_id" {
  value = module.vpc.subnet_a_id
}

output "vpc_subnet_b_id" {
  value = module.vpc.subnet_b_id
}

output "vpc_subnet_c_id" {
  value = module.vpc.subnet_c_id
}