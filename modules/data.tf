data "aws_vpcs" "vpc" {
  tags = {
    Environment = var.environment
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = data.aws_vpcs.vpc.ids
  }

  tags = {
    Tier        = "private"
    Environment = "dev"
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = data.aws_vpcs.vpc.ids
  }

  tags = {
    Tier        = "public"
    Environment = "dev"
  }
}

data "aws_ami" "ecs-ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-2.0.20211120-x86_64-ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["591542846629"]
}