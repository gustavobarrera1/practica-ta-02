module "ecr" {
  source = "./modules/ecr"
}

# module "ecs" {
#   source = "./modules/ecs"

#   depends_on = [ module.ecr ]
# }