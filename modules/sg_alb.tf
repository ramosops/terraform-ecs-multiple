//SECURITY GROUP FOR ALB
resource "aws_security_group" "alb_public" {
  name        = "secgrp-alb-${var.environment}-ecs"
  description = "Allow HTTP and HTTPS inbound Traffic"
  vpc_id      = data.aws_vpcs.vpc.ids[0]
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "alb_internal" {
  name        = "secgrp-alb-internal-${var.environment}-ecs"
  description = "Allow HTTP and HTTPS internal Traffic"
  vpc_id      = data.aws_vpcs.vpc.ids[0]
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["172.32.0.0/16"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["172.32.0.0/16"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["172.32.0.0/16"]
  }
}