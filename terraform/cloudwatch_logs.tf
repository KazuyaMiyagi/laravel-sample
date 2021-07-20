resource "aws_cloudwatch_log_group" "main" {
  name = "/ecs/${var.application}"
}

resource "aws_cloudwatch_log_group" "webserver" {
  name = "/ecs/${var.application}-webserver"
}

resource "aws_cloudwatch_log_group" "scheduler" {
  name = "/ecs/${var.application}-scheduler"
}

resource "aws_cloudwatch_log_group" "worker" {
  name = "/ecs/${var.application}-worker"
}

resource "aws_cloudwatch_log_group" "echo" {
  name = "/ecs/${var.application}-echo"
}

resource "aws_cloudwatch_log_group" "ecs_execute_command" {
  name = "/ecs/${var.application}-ecs-execute-command"
}

resource "aws_cloudwatch_log_group" "codebuild_builder" {
  name = "/aws/codebuild/${var.application}/builder"
}
