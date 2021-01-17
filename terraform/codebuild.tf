locals {
  ecr_base_url     = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com"
  deploy_image_tag = "develop"
  standard_image   = "aws/codebuild/standard:2.0"
}

# container builder projects

resource "aws_codebuild_project" "container_builder" {
  name         = "laravel-container-builder"
  description  = "Container build project for laravel."
  service_role = aws_iam_role.codebuild.arn

  source {
    insecure_ssl        = false
    report_build_status = false
    type                = "NO_SOURCE"
    buildspec           = file("./buildspec/container_builder.yml")
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
    image                       = local.standard_image
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    environment_variable {
      name  = "DOCKER_BUILDKIT"
      type  = "PLAINTEXT"
      value = "1"
    }

    environment_variable {
      name  = "ECR_REPOSITORY_NAME"
      type  = "PLAINTEXT"
      value = aws_ecr_repository.laravel.name
    }

    environment_variable {
      name  = "TARGET_STAGE"
      type  = "PLAINTEXT"
      value = "develop"
    }

    environment_variable {
      name  = "ARTIFACT_DIR"
      type  = "PLAINTEXT"
      value = "/tmp/artifact"
    }

    environment_variable {
      name  = "DOCKERHUB_USERNAME"
      type  = "SECRETS_MANAGER"
      value = "${aws_secretsmanager_secret.codebuild_dockerhubcredential.arn}:USERNAME"
    }

    environment_variable {
      name  = "DOCKERHUB_PASSWORD"
      type  = "SECRETS_MANAGER"
      value = "${aws_secretsmanager_secret.codebuild_dockerhubcredential.arn}:PASSWORD"
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
