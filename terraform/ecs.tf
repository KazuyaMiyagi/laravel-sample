resource "aws_ecs_cluster" "laravel" {
  name = "laravel"
}

resource "aws_ecs_task_definition" "laravel" {
  family             = "laravel"
  network_mode       = "awsvpc"
  cpu                = "256"
  memory             = "512"
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  container_definitions = templatefile("templates/laravel.json.tmpl", {
    name           = "laravel"
    image          = "${aws_ecr_repository.laravel.repository_url}:latest"
    command        = "laravel"
    awslogs_group  = "/ecs/laravel"
    awslogs_region = data.aws_region.current.name
    secrets_arn    = aws_secretsmanager_secret.laravel.arn
  })

  requires_compatibilities = [
    "FARGATE",
  ]
}

resource "aws_ecs_service" "laravel" {
  name                               = "laravel"
  cluster                            = aws_ecs_cluster.laravel.arn
  task_definition                    = aws_ecs_task_definition.laravel.arn
  desired_count                      = 1
  launch_type                        = "FARGATE"
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  network_configuration {
    subnets = [
      aws_subnet.public_0.id,
      aws_subnet.public_1.id
    ]
    security_groups = [
      aws_security_group.laravel.id
    ]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.blue.arn
    container_name   = "laravel"
    container_port   = 80
  }

  lifecycle {
    ignore_changes = [
      desired_count,
      task_definition,
      # CodeDeploy automatically changes the load_balancer
      load_balancer,
    ]
  }

  depends_on = [
    aws_lb.main
  ]
}

resource "aws_ecs_task_definition" "laravel_scheduler" {
  family             = "laravel-scheduler"
  network_mode       = "awsvpc"
  cpu                = "256"
  memory             = "512"
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  container_definitions = templatefile("templates/laravel.json.tmpl", {
    name           = "laravel-scheduler"
    image          = "${aws_ecr_repository.laravel.repository_url}:latest"
    command        = "laravel-scheduler"
    awslogs_group  = "/ecs/laravel-scheduler"
    awslogs_region = data.aws_region.current.name
    secrets_arn    = aws_secretsmanager_secret.laravel.arn
  })
  requires_compatibilities = [
    "FARGATE",
  ]
}

resource "aws_ecs_service" "laravel_scheduler" {
  name                               = "laravel-scheduler"
  cluster                            = aws_ecs_cluster.laravel.arn
  task_definition                    = aws_ecs_task_definition.laravel_scheduler.arn
  desired_count                      = 1
  launch_type                        = "FARGATE"
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100

  network_configuration {
    subnets = [
      aws_subnet.public_0.id,
      aws_subnet.public_1.id
    ]
    security_groups = [
      aws_security_group.laravel.id
    ]
    assign_public_ip = true
  }

  lifecycle {
    ignore_changes = [
      desired_count,
      task_definition,
    ]
  }
}

resource "aws_ecs_task_definition" "laravel_worker" {
  family             = "laravel-worker"
  network_mode       = "awsvpc"
  cpu                = "256"
  memory             = "512"
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  container_definitions = templatefile("templates/laravel.json.tmpl", {
    name           = "laravel-worker"
    image          = "${aws_ecr_repository.laravel.repository_url}:latest"
    command        = "laravel-worker"
    awslogs_group  = "/ecs/laravel-worker"
    awslogs_region = data.aws_region.current.name
    secrets_arn    = aws_secretsmanager_secret.laravel.arn
  })
  requires_compatibilities = [
    "FARGATE",
  ]
}

resource "aws_ecs_service" "laravel_worker" {
  name                               = "laravel-worker"
  cluster                            = aws_ecs_cluster.laravel.arn
  task_definition                    = aws_ecs_task_definition.laravel_worker.arn
  desired_count                      = 1
  launch_type                        = "FARGATE"
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100

  network_configuration {
    subnets = [
      aws_subnet.public_0.id,
      aws_subnet.public_1.id
    ]
    security_groups = [
      aws_security_group.laravel.id
    ]
    assign_public_ip = true
  }

  lifecycle {
    ignore_changes = [
      desired_count,
      task_definition,
    ]
  }
}
