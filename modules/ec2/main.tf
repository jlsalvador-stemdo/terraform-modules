data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  owners = ["099720109477"]
}
resource "aws_security_group" "ec2" {
    name = "${var.project_name}-sg-ec2"
    vpc_id = var.vpc_id

    ingress {
    from_port       = var.aws_security_group_port_ingress
    to_port         = var.aws_security_group_port_ingress
    protocol        = var.aws_security_group_ingress_protocol
    security_groups = [var.alb_security_group_id]
    }

    egress {
    from_port       = var.aws_security_group_port_egress
    to_port         = var.aws_security_group_port_egress
    protocol    = var.aws_security_group_egress_protocol
    cidr_blocks = var.aws_security_group_cidr_blocks
    }
}

resource "aws_instance" "web" {
  for_each = var.instances

  ami                    = data.aws_ami.ubuntu.id
  instance_type          = each.value.instance_type
  subnet_id              = each.value.subnet_id
  vpc_security_group_ids = [aws_security_group.ec2.id]
  
  # Añade esto para que la instancia sea accesible
  associate_public_ip_address = true 

  # IMPORTANTE: Permitir que el script acceda a los metadatos
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "optional" # Esto facilita que el script funcione sin fallos de token
  }

  user_data = <<-EOF
#!/bin/bash
apt-get update -y
apt-get install -y apache2
systemctl start apache2
systemctl enable apache2

# Obtener metadatos (Token para seguridad)
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/instance-id)
HOSTNAME=$(hostname)

# Crear el index.html en la ruta de Ubuntu
cat <<HTML > /var/www/html/index.html
<h1>Hola Mundo desde Ubuntu</h1>
<p>Instance ID: $INSTANCE_ID</p>
<p>Hostname: $HOSTNAME</p>
HTML

# Reiniciar para asegurar
systemctl restart apache2
EOF

  tags = {
    Name = "${var.project_name}-${each.key}"
  }
}

# I define this here and not in the alb module cause the ec2 module 
# is the only one that know about the ids of the instances to attach
resource "aws_lb_target_group_attachment" "web" {
  for_each = aws_instance.web

  target_group_arn = var.target_group_arn
  target_id        = each.value.id
  port             = var.aws_lb_target_group_attachment_port
}


