resource "aws_ecs_cluster" "main" {
  name = var.application
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "main" {
  family             = var.application
  network_mode       = "awsvpc"
  cpu                = var.ecs_cpu
  memory             = var.ecs_memory
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn
  container_definitions = templatefile("templates/taskdef.json.tpl", {
    name           = var.application
    image          = "${aws_ecr_repository.main.repository_url}:latest"
    command        = var.laravel_command
    awslogs_group  = local.cloudwatch_log_group_name.main
    awslogs_region = data.aws_region.current.name
    secrets_arn    = aws_secretsmanager_secret.main.arn

    webserver_name          = "${var.application}-webserver"
    webserver_command       = var.webserver_command
    webserver_awslogs_group = local.cloudwatch_log_group_name.webserver
  })

  requires_compatibilities = [
    "FARGATE",
  ]
}

resource "aws_ecs_service" "main" {
  name                               = var.application
  cluster                            = aws_ecs_cluster.main.arn
  task_definition                    = aws_ecs_task_definition.main.arn
  desired_count                      = 0
  launch_type                        = "FARGATE"
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  health_check_grace_period_seconds  = 60

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  network_configuration {
    subnets = [
      aws_subnet.public_0.id,
      aws_subnet.public_1.id
    ]
    security_groups = [
      aws_security_group.main.id
    ]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.blue-green[0].arn
    container_name   = "${var.application}-webserver"
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

resource "aws_ecs_task_definition" "scheduler" {
  family             = "${var.application}-scheduler"
  network_mode       = "awsvpc"
  cpu                = var.ecs_cpu
  memory             = var.ecs_memory
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn
  container_definitions = templatefile("templates/taskdef-scheduler-worker.json.tpl", {
    name           = "${var.application}-scheduler"
    image          = "${aws_ecr_repository.main.repository_url}:latest"
    command        = var.scheduler_command
    awslogs_group  = local.cloudwatch_log_group_name.scheduler
    awslogs_region = data.aws_region.current.name
    secrets_arn    = aws_secretsmanager_secret.main.arn
  })
  requires_compatibilities = [
    "FARGATE",
  ]
}

resource "aws_ecs_service" "scheduler" {
  name                               = "${var.application}-scheduler"
  cluster                            = aws_ecs_cluster.main.arn
  task_definition                    = aws_ecs_task_definition.scheduler.arn
  desired_count                      = 0
  launch_type                        = "FARGATE"
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100

  network_configuration {
    subnets = [
      aws_subnet.public_0.id,
      aws_subnet.public_1.id
    ]
    security_groups = [
      aws_security_group.main.id
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

resource "aws_ecs_task_definition" "worker" {
  family             = "${var.application}-worker"
  network_mode       = "awsvpc"
  cpu                = var.ecs_cpu
  memory             = var.ecs_memory
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn
  container_definitions = templatefile("templates/taskdef-scheduler-worker.json.tpl", {
    name           = "${var.application}-worker"
    image          = "${aws_ecr_repository.main.repository_url}:latest"
    command        = var.worker_command
    awslogs_group  = local.cloudwatch_log_group_name.worker
    awslogs_region = data.aws_region.current.name
    secrets_arn    = aws_secretsmanager_secret.main.arn
  })
  requires_compatibilities = [
    "FARGATE",
  ]
}

resource "aws_ecs_service" "worker" {
  name                               = "${var.application}-worker"
  cluster                            = aws_ecs_cluster.main.arn
  task_definition                    = aws_ecs_task_definition.worker.arn
  desired_count                      = 0
  launch_type                        = "FARGATE"
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100

  network_configuration {
    subnets = [
      aws_subnet.public_0.id,
      aws_subnet.public_1.id
    ]
    security_groups = [
      aws_security_group.main.id
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

# echo
resource "aws_ecs_task_definition" "echo" {
  family             = "${var.application}-echo"
  network_mode       = "awsvpc"
  cpu                = var.ecs_cpu
  memory             = var.ecs_memory
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn
  container_definitions = templatefile("templates/taskdef-echo.json.tpl", {
    name           = "${var.application}-echo"
    image          = "${aws_ecr_repository.echo.repository_url}:latest"
    awslogs_group  = local.cloudwatch_log_group_name.echo
    awslogs_region = data.aws_region.current.name
    secrets_arn    = aws_secretsmanager_secret.main.arn

    laravel_echo_server_auth_host      = var.laravel_echo_server_auth_host
    laravel_echo_server_debug          = var.laravel_echo_server_debug
    laravel_echo_server_host           = var.laravel_echo_server_host
    laravel_echo_server_port           = var.laravel_echo_server_port
    laravel_echo_server_proto          = var.laravel_echo_server_proto
    laravel_echo_server_redis_host     = var.laravel_echo_server_redis_host
    laravel_echo_server_redis_password = var.laravel_echo_server_redis_password
    laravel_echo_server_redis_port     = var.laravel_echo_server_redis_port
    laravel_echo_server_ssl_cert       = var.laravel_echo_server_ssl_cert
    laravel_echo_server_ssl_chain      = var.laravel_echo_server_ssl_chain
    laravel_echo_server_ssl_key        = var.laravel_echo_server_ssl_key
    laravel_echo_server_ssl_pass       = var.laravel_echo_server_ssl_pass
  })
  requires_compatibilities = [
    "FARGATE",
  ]
}

resource "aws_ecs_service" "echo" {
  name                               = "${var.application}-echo"
  cluster                            = aws_ecs_cluster.main.arn
  task_definition                    = aws_ecs_task_definition.echo.arn
  desired_count                      = 0
  launch_type                        = "FARGATE"
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100

  network_configuration {
    subnets = [
      aws_subnet.public_0.id,
      aws_subnet.public_1.id
    ]
    security_groups = [
      aws_security_group.echo.id
    ]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.echo.arn
    container_name   = "${var.application}-echo"
    container_port   = 6001
  }

  lifecycle {
    ignore_changes = [
      desired_count,
      task_definition,
    ]
  }

  depends_on = [
    aws_lb.main
  ]
}
