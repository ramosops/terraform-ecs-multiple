resource "aws_ecs_cluster" "ecs_cluster" {
  name = "ecs-cluster-${var.environment}"
}

resource "aws_ecs_service" "frontend" {
  for_each        = var.service_config
  name            = each.value.name
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = each.value.arn
  desired_count   = each.value.tasks
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = each.value.is_public == true ? aws_alb_target_group.tg_public[each.key].arn : aws_alb_target_group.tg_internal[each.key].arn
    container_name   = each.value.container_name
    container_port   = 80
  }

  network_configuration {
    security_groups = [aws_security_group.ecs_service.id]
    subnets         = data.aws_subnets.private.ids[*]
  }
}