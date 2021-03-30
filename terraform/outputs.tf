output "route53_zone_name_servers" {
  value = aws_route53_zone.main.name_servers
}

output "terraform_managed_taskdef_revisions" {
  value = {
    "main"      = aws_ecs_task_definition.main.revision
    "echo"      = aws_ecs_task_definition.echo.revision
    "scheduler" = aws_ecs_task_definition.scheduler.revision
    "worker"    = aws_ecs_task_definition.worker.revision
  }
}

output "current_ecs_service_taskdef_revisions" {
  value = {
    "main"      = tonumber(regex(":(\\d+)$", aws_ecs_service.main.task_definition)[0])
    "echo"      = tonumber(regex(":(\\d+)$", aws_ecs_service.echo.task_definition)[0])
    "scheduler" = tonumber(regex(":(\\d+)$", aws_ecs_service.scheduler.task_definition)[0])
    "worker"    = tonumber(regex(":(\\d+)$", aws_ecs_service.worker.task_definition)[0])
  }
}
