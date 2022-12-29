resource "aws_security_group" "ecs_service" {
  name        = "segrp-ecs-public-${var.environment}-service"
  description = "Allow HTTP inbound Traffic"
  vpc_id      = data.aws_vpcs.vpc.ids[0]

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# resource "aws_security_group" "ecs_service_internal" {
#   name        = "segrp-ecs-internal-${var.environment}-service"
#   description = "Allow HTTP internal Traffic"
#   vpc_id      = data.aws_vpcs.vpc.ids[0]

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["172.32.0.0/16"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["172.32.0.0/16"]
#   }
# }