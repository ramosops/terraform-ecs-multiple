resource "aws_alb" "public_alb" {
  name                             = "alb-public-${var.environment}-ecs-cluster"
  security_groups                  = [aws_security_group.alb_public.id]
  subnets                          = data.aws_subnets.public.ids[*]
  internal                         = false
  load_balancer_type               = "application"
  enable_cross_zone_load_balancing = true
  enable_deletion_protection       = false
}

resource "aws_alb" "internal_alb" {
  name                             = "alb-internal-${var.environment}-ecs-cluster"
  security_groups                  = [aws_security_group.alb_internal.id]
  subnets                          = data.aws_subnets.private.ids[*]
  internal                         = true
  load_balancer_type               = "application"
  enable_cross_zone_load_balancing = true
  enable_deletion_protection       = false
}

resource "aws_alb_target_group" "tg_internal" {
  for_each             = { for service, config in var.service_config : service => config.target_groups if !config.is_public }
  name                 = "${var.environment}-tg01-internal-${each.key}"
  port                 = each.value.port
  protocol             = each.value.protocol
  target_type          = "ip"
  vpc_id               = data.aws_vpcs.vpc.ids[0]
  deregistration_delay = 30

  health_check {
    path                = each.value.path
    port                = each.value.port_check
    healthy_threshold   = each.value.healthy_threshold
    unhealthy_threshold = each.value.unhealthy_threshold
    timeout             = each.value.timeout
    interval            = each.value.interval
    matcher             = each.value.matcher
  }
}

resource "aws_alb_target_group" "tg_public" {
  for_each             = { for service, config in var.service_config : service => config.target_groups if config.is_public }
  name                 = "${var.environment}-tg01-public-${each.key}"
  port                 = each.value.port
  protocol             = each.value.protocol
  target_type          = "ip"
  vpc_id               = data.aws_vpcs.vpc.ids[0]
  deregistration_delay = 30

  health_check {
    path                = each.value.path
    port                = each.value.port_check
    healthy_threshold   = each.value.healthy_threshold
    unhealthy_threshold = each.value.unhealthy_threshold
    timeout             = each.value.timeout
    interval            = each.value.interval
    matcher             = each.value.matcher
  }
}

resource "aws_lb_listener" "listener_redirect" {
  load_balancer_arn = aws_alb.public_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_listener" "listener_public" {
  load_balancer_arn = aws_alb.public_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_ssl
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "No routes defined"
      status_code  = "200"
    }
  }
}

resource "aws_alb_listener" "listener_internal" {
  load_balancer_arn = aws_alb.internal_alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "No routes defined"
      status_code  = "200"
    }
  }
}

resource "aws_alb_listener_rule" "alb_listener_rule_internal" {
  for_each     = { for service, config in var.service_config : service => config.target_groups if !config.is_public }
  listener_arn = aws_alb_listener.listener_internal.arn
  priority     = each.value.priority
  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.tg_internal[each.key].arn
  }
  condition {
    path_pattern {
      values = [each.value.path_pattern]
    }
  }
}

resource "aws_alb_listener_rule" "alb_listener_rule_public" {
  for_each     = { for service, config in var.service_config : service => config.target_groups if config.is_public }
  listener_arn = aws_alb_listener.listener_public.arn
  priority     = each.value.priority
  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.tg_public[each.key].arn
  }
  condition {
    path_pattern {
      values = [each.value.path_pattern]
    }
  }
}
