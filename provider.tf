provider "aws" {
  region                   = var.region
  shared_config_files      = ["/home/diego/.aws/config"]
  shared_credentials_files = ["/home/diego/.aws/credentials"]
  profile                  = "default"
  default_tags {
    tags = {
      Terraform = "yes"
    }
  }
}