resource "aws_lb" "this" {
    name               = "${var.project_name}-alb"
    internal           = var.internal
    load_balancer_type = "application"
    security_groups   = [aws_security_group.this.id] #local reference to security group
    subnets           = var.subnet_ids
}

resource "aws_security_group" "this" {
    name       = "${var.project_name}-sg-alb"
    description = "Security group for ALB ${var.project_name}"
    vpc_id      = var.vpc_id

    ingress {
        from_port   = var.port_ingress
        to_port     = var.port_ingress
        protocol    = var.ingress_protocol
        cidr_blocks = var.allowed_cidr_blocks_ingress
    }

    egress {
        from_port   = var.port_egress
        to_port     = var.port_egress
        protocol    = var.egress_protocol
        cidr_blocks = var.allowed_cidr_blocks_egress
    }
}

resource "aws_lb_target_group" "this" {
    name     = "${var.project_name}-tg"
    port     = var.port_ingress
    protocol = var.ingress_protocol
    vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "this" {
    load_balancer_arn = aws_lb.this.arn 

    port              = var.port_ingress
    protocol          = var.ingress_protocol

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.this.arn
    }
}