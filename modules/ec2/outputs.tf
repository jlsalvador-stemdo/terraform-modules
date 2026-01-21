output "instance_ids" {
    description = "EC2 Instance IDs for using in ALB"
    value = aws_instance.web[*].id
}