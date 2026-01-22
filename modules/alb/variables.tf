variable "project_name" {
  description = "The name of the project."
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs to attach to the ALB."
  type        = list(string)
}

variable "vpc_id" {
  description = "The ID of the VPC where the ALB will be deployed."
  type        = string
}

variable "internal" {
  description = "Boolean to specify if the ALB is internal or internet-facing."
  type        = bool
  default     = false
}

variable "port_ingress" {
    description = "The port for ingress traffic to the ALB."
    type       = number
}

variable "allowed_cidr_blocks_ingress" {
    description = "List of CIDR blocks allowed to access the ALB."
    type        = list(string)
    default     = ["0.0.0.0/0"]
}
variable "allowed_cidr_blocks_egress" {
    description = "List of CIDR blocks allowed to exit the ALB."
    type        = list(string)
    default     = ["0.0.0.0/0"]
}

variable "port_egress" {
    description = "The port for egress traffic from the ALB."
    type       = number
}

variable "egress_protocol" {
    description = "The protocol for egress traffic from the ALB."
    type        = string
    default     = "-1"
}

variable "ingress_protocol" {
    description = "The protocol for ingress traffic to the ALB."
    type        = string
    default     = "tcp"

}
variable "security_group_ingress_protocol" {
  description = "Protocol for the ALB security group ingress rule."
  type        = string
  default     = "tcp"
}

variable "listener_protocol" {
  description = "Protocol for the ALB listener (HTTP or HTTPS)."
  type        = string
  default     = "HTTP"
}
