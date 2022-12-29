module "ecs" {
  source         = "./modules"
  region         = var.region
  environment    = var.environment
  billing        = var.billing
  asg_desired    = var.asg_desired
  asg_min_size   = var.asg_min_size
  asg_max_size   = var.asg_max_size
  certificate_ssl = var.certificate_ssl
  service_config = var.service_config
}
