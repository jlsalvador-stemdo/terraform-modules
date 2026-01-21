# Módulos Terraform para AWS

Este repositorio contiene tres módulos independientes de Terraform para desplegar infraestructura básica en AWS:

- **VPC**: creación de red, subredes públicas, gateway de Internet y tablas de rutas.  
- **ALB**: creación de un Application Load Balancer, su Security Group, Target Group y Listener.  
- **EC2**: creación de instancias EC2, su Security Group y registro en el Target Group del ALB.

Cada módulo está diseñado para ser reutilizable y para integrarse mediante variables y outputs.

---

## Estructura del repositorio

```hcl
terraform-modules/
│
├── vpc/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
│
├── alb/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
│
└── ec2/
    ├── main.tf
    ├── variables.tf
    └── outputs.tf
```

---

## Uso de los módulos

A continuación se muestra un ejemplo de cómo integrarlos desde un proyecto externo mediante un archivo `main.tf`.

### Módulo VPC

```hcl
module "vpc" {
  source = "github.com/tuusuario/terraform-modules//vpc"

  project_name        = "miapp"
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
}
```

### Módulo ALB

```hcl
module "alb" {
  source = "github.com/tuusuario/terraform-modules//alb"

  project_name = "miapp"
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.public_subnet_ids

  port_ingress = 80
  port_egress  = 0
}
```

### Módulo EC2

```hcl
module "ec2" {
  source = "github.com/tuusuario/terraform-modules//ec2"

  project_name = "miapp"
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.public_subnet_ids

  alb_security_group_id = module.alb.alb_security_group_id
  target_group_arn      = module.alb.target_group_arn

  instance_type = "t2.micro"
}
```

---

## Dependencias entre módulos

Los módulos se relacionan mediante outputs y variables:

- El módulo **VPC** expone `vpc_id` y `public_subnet_ids`.  
- El módulo **ALB** utiliza esos valores y expone `alb_security_group_id` y `target_group_arn`.  
- El módulo **EC2** recibe ambos valores para configurar su Security Group y registrar las instancias en el Target Group.

---

## Requisitos

- Terraform 1.0 o superior  
- AWS CLI configurado  
- Credenciales con permisos para EC2, VPC y ELBv2  
