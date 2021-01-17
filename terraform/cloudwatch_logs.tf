locals {
  cloudwatch_log_group_name = {
    main      = "/ecs/laravel"
    scheduler = "/ecs/laravel-scheduler"
    worker    = "/ecs/laravel-worker"
    codebuild = {
      builder = "/aws/codebuild/laravel/builder"
    }
  }
}

resource "aws_cloudwatch_log_group" "main" {
  name = local.cloudwatch_log_group_name.main
}

resource "aws_cloudwatch_log_group" "scheduler" {
  name = local.cloudwatch_log_group_name.scheduler
}

resource "aws_cloudwatch_log_group" "worker" {
  name = local.cloudwatch_log_group_name.worker
}

resource "aws_cloudwatch_log_group" "codebuild_builder" {
  name = local.cloudwatch_log_group_name.codebuild.builder
}
