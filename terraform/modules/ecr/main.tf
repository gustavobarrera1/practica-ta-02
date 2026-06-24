resource "aws_ecr_repository" "flask_app_block" {
  name                 = "flask_app_repository"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Environment = "dev"
    Project     = "flask-app"
  }
}