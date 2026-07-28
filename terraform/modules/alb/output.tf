output "lb_target_group_arn" {
  value = aws_lb_target_group.target_group.arn
}

output "sg_lb_id" {
  value = aws_security_group.load_balancer_security_group.id
}