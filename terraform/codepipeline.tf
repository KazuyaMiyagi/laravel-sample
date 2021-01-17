locals {
  artifacts = {
    source = "SourceArtifact"
    build  = "DeployConfigArtifact"
  }
}
resource "aws_codepipeline" "laravel_deploy_pipeline" {
  name     = "laravel-deploy-pipeline"
  role_arn = aws_iam_role.codepipeline.arn

  artifact_store {
    location = aws_s3_bucket.developer_tools.bucket
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      name      = "GitHub"
      category  = "Source"
      owner     = "AWS"
      provider  = "CodeStarSourceConnection"
      run_order = "1"
      version   = "1"

      configuration = {
        "BranchName"           = "main"
        "FullRepositoryId"     = var.laravel_repository
        "ConnectionArn"        = aws_codestarconnections_connection.github.arn
        "OutputArtifactFormat" = "CODEBUILD_CLONE_REF"
      }

      output_artifacts = [
        local.artifacts.source,
      ]
    }
  }

  stage {
    name = "Build"
    action {
      name      = "Container"
      category  = "Build"
      owner     = "AWS"
      provider  = "CodeBuild"
      run_order = "1"
      version   = "1"

      configuration = {
        ProjectName = aws_codebuild_project.container_builder.id
      }

      input_artifacts = [
        local.artifacts.source,
      ]

      output_artifacts = [
        local.artifacts.build,
      ]
    }
  }

  stage {
    name = "Deploy"

    dynamic "action" {
      for_each = var.enable_approve_action ? [1] : []

      content {
        name      = "Waiting_for_approval"
        category  = "Approval"
        owner     = "AWS"
        provider  = "Manual"
        run_order = 1
        version   = "1"
      }
    }

    action {
      name      = "Laravel"
      category  = "Deploy"
      owner     = "AWS"
      provider  = "CodeDeployToECS"
      run_order = var.enable_approve_action ? 2 : 1
      version   = "1"

      configuration = {
        AppSpecTemplateArtifact        = local.artifacts.build
        ApplicationName                = aws_codedeploy_app.main.name
        DeploymentGroupName            = aws_codedeploy_deployment_group.main.deployment_group_name
        Image1ArtifactName             = local.artifacts.build
        Image1ContainerName            = "IMAGE_NAME"
        TaskDefinitionTemplateArtifact = local.artifacts.build
      }

      input_artifacts = [
        local.artifacts.build,
      ]
    }

    action {
      name      = "Laravel_Scheduler"
      category  = "Deploy"
      owner     = "AWS"
      provider  = "ECS"
      run_order = var.enable_approve_action ? 2 : 1
      version   = "1"

      configuration = {
        ClusterName = aws_ecs_cluster.laravel.name
        FileName    = "laravel-scheduler-imagedefinitions.json"
        ServiceName = aws_ecs_service.laravel_scheduler.name
      }

      input_artifacts = [
        local.artifacts.build,
      ]
    }

    action {
      name      = "Laravel_Worker"
      category  = "Deploy"
      owner     = "AWS"
      provider  = "ECS"
      run_order = var.enable_approve_action ? 2 : 1
      version   = "1"

      configuration = {
        ClusterName = aws_ecs_cluster.laravel.name
        FileName    = "laravel-worker-imagedefinitions.json"
        ServiceName = aws_ecs_service.laravel_worker.name
      }

      input_artifacts = [
        local.artifacts.build,
      ]
    }
  }

  depends_on = [
    aws_iam_role.codepipeline
  ]
}
