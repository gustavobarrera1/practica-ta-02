module "vpc" {
  source = "./modules/vpc"

}

module "alb" {
  source = "./modules/alb"

  default_vpc_id = module.vpc.default_vpc_id

  subnet_a_id = module.vpc.subnet_a_id
  subnet_b_id = module.vpc.subnet_b_id
  subnet_c_id = module.vpc.subnet_c_id

}

module "ecr" {
  source = "./modules/ecr"
}

module "ecs" {
  source = "./modules/ecs"

  ecs_task_def_cpu    = var.ecs_task_def_cpu
  ecs_task_def_memory = var.ecs_task_def_memory

  subnet_a_id = module.vpc.subnet_a_id
  subnet_b_id = module.vpc.subnet_b_id
  subnet_c_id = module.vpc.subnet_c_id

  lb_target_group_arn = module.alb.lb_target_group_arn

  sg_lb_id = module.alb.sg_lb_id

  depends_on = [module.ecr, module.alb]
}

