variable "vpc_id" {
    description = "VPC id"
    type = string
}

variable "subnet_ids" {
    description = "VPC subnets ids"
    type = list(string)
}

variable "alb_security_group_id" {
    description = "ALB Security Group ID" # EC2 only allow connections from ALB 
    type = string
}

variable "target_group_arn" {
    description = "Target group ARN" # ARN means adress resource name
    type = string
}

variable "instance_type" {
    description = "(Optional) EC2 instance type"
    type = string
    default = "t2.micro"
}

variable "aws_security_group_port_egress" {
    description = "(Optional) Communication egress port"
    type = number
    default = 80
}

variable "aws_security_group_port_ingress" {
    description = "(Optional) Communication ingress port"
    type = number
    default = 80
}

variable "aws_security_group_cidr_blocks" {
    description = "CIDR Blocks"
    type = list(string)
    default = ["0.0.0.0/0"]
}

variable "aws_security_group_ingress_protocol" {
    description = "Ingress SG protocol"
    type = string
    default = "tcp"
}

variable "aws_lb_target_group_attachment_port" {
    description = "(Optional) Communication port for the target group attachment"
    type = number
    default = 80
}

variable "alb_security_group_id" { 
    type = string 
}
variable "target_group_arn" { 
    type = string 
}
