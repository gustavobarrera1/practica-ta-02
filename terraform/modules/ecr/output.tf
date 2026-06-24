output "ecr_url" {
  description = "ecr_url"
  value       = aws_ecr_repository.flask_app_block.repository_url
}
