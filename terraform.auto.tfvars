region       = "us-east-2"
environment  = "dev"
billing      = "Infra"
asg_desired  = 1
asg_min_size = 1
asg_max_size = 1
certificate_ssl = "arn:aws:acm:us-east-1:099723967292:certificate/4d1888a6-1d69-432c-a511-b6b640e91b09"
service_config = {
  "frontend" = {
    name           = "frontend"
    is_public      = true
    arn            = "arn:aws:ecs:us-east-2:099723967292:task-definition/dev-recriar-frontend:1"
    tasks          = 1
    container_name = "dev-recriar-frontend"
    target_groups = {
      name                = "frontend"
      port                = 80
      protocol            = "HTTP"
      path                = "/"
      port_check          = "traffic-port"
      healthy_threshold   = 5
      unhealthy_threshold = 3
      timeout             = 5
      interval            = 30
      matcher             = "200"
      priority            = 100
      path_pattern        = "/*"
    }
  },
  "loki" = {
    name           = "loki"
    is_public      = false
    arn            = "arn:aws:ecs:us-east-2:099723967292:task-definition/loki-api:1"
    tasks          = 1
    container_name = "loki-api"
    target_groups = {
      name                = "loki"
      port                = 80
      protocol            = "HTTP"
      path                = "/loki/swagger/index.html"
      port_check          = "traffic-port"
      healthy_threshold   = 5
      unhealthy_threshold = 3
      timeout             = 5
      interval            = 30
      matcher             = "200"
      priority            = 100
      path_pattern        = "/loki/*"
    }
  },
  "backend-nest" = {
    name           = "backend-nest"
    is_public      = false
    arn            = "arn:aws:ecs:us-east-2:099723967292:task-definition/backend-nest:1"
    tasks          = 1
    container_name = "backend-nest"
    target_groups = {
      name                = "backend-nest"
      port                = 80
      protocol            = "HTTP"
      path                = "/backend-nest/status"
      port_check          = "traffic-port"
      healthy_threshold   = 5
      unhealthy_threshold = 3
      timeout             = 5
      interval            = 30
      matcher             = "200"
      priority            = 90
      path_pattern        = "/backend-nest/*"
    }
  }
}
