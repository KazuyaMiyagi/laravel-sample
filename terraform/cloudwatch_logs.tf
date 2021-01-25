locals {
  cloudwatch_log_group_name = {
    main      = "/ecs/${var.application}"
    webserver = "/ecs/${var.application}-webserver"
    scheduler = "/ecs/${var.application}-scheduler"
    worker    = "/ecs/${var.application}-worker"
    echo      = "/ecs/${var.application}-echo"
    codebuild = {
      builder = "/aws/codebuild/${var.application}/builder"
    }
  }
}

resource "aws_cloudwatch_log_group" "main" {
  name = local.cloudwatch_log_group_name.main
}

resource "aws_cloudwatch_log_group" "webserver" {
  name = local.cloudwatch_log_group_name.webserver
}

resource "aws_cloudwatch_log_group" "scheduler" {
  name = local.cloudwatch_log_group_name.scheduler
}

resource "aws_cloudwatch_log_group" "worker" {
  name = local.cloudwatch_log_group_name.worker
}

resource "aws_cloudwatch_log_group" "echo" {
  name = local.cloudwatch_log_group_name.echo
}

resource "aws_cloudwatch_log_group" "codebuild_builder" {
  name = local.cloudwatch_log_group_name.codebuild.builder
}
