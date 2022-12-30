module "ecs" {
  source         = "./modules"
  region         = var.region
  environment    = var.environment
  billing        = var.billing
  certificate_ssl = var.certificate_ssl
  service_config = var.service_config
}
