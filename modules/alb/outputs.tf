output "alb_security_group_id" {
  description = "Security Group ID of the ALB"
  value       = aws_security_group.this.id
}

output "target_group_arn" {
  description = "ARN of the ALB Target Group"
  value       = aws_lb_target_group.this.arn
}
