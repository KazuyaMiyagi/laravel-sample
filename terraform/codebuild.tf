resource "aws_codebuild_project" "container_builder" {
  name         = "${var.application}-container-builder"
  description  = "Build a Docker image to register to ECR for ${var.application}"
  service_role = aws_iam_role.codebuild.arn

  source {
    insecure_ssl        = false
    report_build_status = false
    type                = "NO_SOURCE"
    buildspec           = file("./files/container_builder.yml")
  }

  logs_config {
    cloudwatch_logs {
      status     = "ENABLED"
      group_name = aws_cloudwatch_log_group.codebuild_builder.name
    }

    s3_logs {
      status = "DISABLED"
    }
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:2.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    environment_variable {
      name  = "APPLICATION"
      type  = "PLAINTEXT"
      value = var.application
    }

    environment_variable {
      name  = "DOCKERHUB_PASSWORD"
      type  = "SECRETS_MANAGER"
      value = "${aws_secretsmanager_secret.dockerhub.arn}:PASSWORD::"
    }

    environment_variable {
      name  = "DOCKERHUB_USERNAME"
      type  = "SECRETS_MANAGER"
      value = "${aws_secretsmanager_secret.dockerhub.arn}:USERNAME::"
    }

    environment_variable {
      name  = "ECR_REPOSITORY_NAME"
      type  = "PLAINTEXT"
      value = aws_ecr_repository.main.name
    }

    environment_variable {
      name  = "IMAGE1_PLACEHOLDER"
      type  = "PLAINTEXT"
      value = "<${local.image1_container_name}>"
    }

    environment_variable {
      name  = "TARGET_STAGE"
      type  = "PLAINTEXT"
      value = var.docker_build_target
    }
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type = "LOCAL"
    modes = [
      "LOCAL_DOCKER_LAYER_CACHE",
    ]
  }

  depends_on = [
    aws_iam_role.codebuild,
  ]
}
