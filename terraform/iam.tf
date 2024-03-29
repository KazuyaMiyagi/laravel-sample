# EcsTaskExecutionRole
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${title(var.application)}-EcsTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role_assumerole.json
}

data "aws_iam_policy_document" "ecs_task_execution_role_assumerole" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"

      identifiers = [
        "ecs-tasks.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role_policy" "ecs_task_execution_role" {
  name   = "${title(var.application)}-EcsTaskExecutionRole"
  role   = aws_iam_role.ecs_task_execution_role.id
  policy = data.aws_iam_policy_document.ecs_task_execution_role.json
}

data "aws_iam_policy_document" "ecs_task_execution_role" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "secretsmanager:GetSecretValue",
    ]
    effect = "Allow"

    resources = [
      aws_secretsmanager_secret.main.arn
    ]
  }
}

# EcsTaskRole
resource "aws_iam_role" "ecs_task_role" {
  name               = "${title(var.application)}-EcsTaskRole"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_role_assumerole.json
}

data "aws_iam_policy_document" "ecs_task_role_assumerole" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"

      identifiers = [
        "ecs-tasks.amazonaws.com",
      ]
    }
  }
}

data "aws_iam_policy_document" "ecs_task_role_policy" {
  statement {
    effect = "Allow"
    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel",
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:DescribeLogGroups",
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents",
    ]
    resources = [
      aws_cloudwatch_log_group.ecs_execute_command.arn,
      "${aws_cloudwatch_log_group.ecs_execute_command.arn}:*",
    ]
  }
}

resource "aws_iam_role_policy" "ecs_task_role_policy" {
  name   = "${title(var.application)}-EcsTaskRole"
  role   = aws_iam_role.ecs_task_role.id
  policy = data.aws_iam_policy_document.ecs_task_role_policy.json
}

# Codebuild
data "aws_iam_policy_document" "codebuild_assumerole" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "codebuild" {
  # Actions that need to target all resources
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "secretsmanager:GetRandomPassword",
      "secretsmanager:ListSecrets"
    ]
    resources = [
      "*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "ecr:*"
    ]
    resources = [
      aws_ecr_repository.main.arn
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:List*",
      "s3:Get*",
      "s3:PutObject"
    ]
    resources = [
      aws_s3_bucket.developer_tools.arn,
      "${aws_s3_bucket.developer_tools.arn}/*",
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      aws_cloudwatch_log_group.codebuild_builder.arn,
      "${aws_cloudwatch_log_group.codebuild_builder.arn}:*",
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds"
    ]
    resources = [
      aws_secretsmanager_secret.dockerhub.arn,
      aws_secretsmanager_secret.github.arn,
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "codestar-connections:UseConnection"
    ]
    resources = [
      "*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "ecs:DescribeTaskDefinition"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role" "codebuild" {
  name               = "${title(var.application)}-Codebuild"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assumerole.json
}

resource "aws_iam_role_policy" "codebuild" {
  name   = "${title(var.application)}-Codebuild"
  role   = aws_iam_role.codebuild.id
  policy = data.aws_iam_policy_document.codebuild.json
}

# CodePipeline
data "aws_iam_policy_document" "codepipeline_assumerole" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "codepipeline" {
  statement {
    effect = "Allow"
    actions = [
      "iam:PassRole"
    ]
    resources = [
      "*"
    ]
    condition {
      test     = "StringEqualsIfExists"
      variable = "iam:PassedToService"

      values = [
        "cloudformation.amazonaws.com",
        "elasticbeanstalk.amazonaws.com",
        "ec2.amazonaws.com",
        "ecs-tasks.amazonaws.com",
      ]
    }
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:*"
    ]
    resources = [
      aws_s3_bucket.developer_tools.arn,
      "${aws_s3_bucket.developer_tools.arn}/*",
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
    ]
    resources = [
      "*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "codedeploy:CreateDeployment",
      "codedeploy:GetApplication",
      "codedeploy:GetApplicationRevision",
      "codedeploy:GetDeployment",
      "codedeploy:GetDeploymentConfig",
      "codedeploy:RegisterApplicationRevision",
      "elasticloadbalancing:*",
      "cloudwatch:*",
      "sns:*",
      "ecs:*",
      "lambda:InvokeFunction",
      "lambda:ListFunctions",
      "ecr:DescribeImages",
      "codestar-connections:UseConnection"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role" "codepipeline" {
  name               = "${title(var.application)}-CodePipeline"
  assume_role_policy = data.aws_iam_policy_document.codepipeline_assumerole.json
}

resource "aws_iam_role_policy" "codepipeline" {
  name   = "${title(var.application)}-CodePipeline"
  role   = aws_iam_role.codepipeline.id
  policy = data.aws_iam_policy_document.codepipeline.json
}

# CodeDeploy
resource "aws_iam_role" "codedeploy" {
  name               = "${title(var.application)}-CodeDeploy"
  assume_role_policy = data.aws_iam_policy_document.codedeploy_assumerole.json
}

data "aws_iam_policy_document" "codedeploy_assumerole" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"

      identifiers = [
        "codedeploy.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role_policy" "codedeploy" {
  name   = "${title(var.application)}-CodeDeploy"
  role   = aws_iam_role.codedeploy.id
  policy = data.aws_iam_policy_document.codedeploy.json
}

data "aws_iam_policy_document" "codedeploy" {
  statement {
    effect    = "Allow"
    actions   = ["iam:PassRole"]
    resources = ["*"]
    condition {
      test     = "StringLike"
      variable = "iam:PassedToService"
      values = [
        "ecs-tasks.amazonaws.com"
      ]
    }
  }
  statement {
    effect = "Allow"
    actions = [
      "ecs:DescribeServices",
      "ecs:CreateTaskSet",
      "ecs:UpdateServicePrimaryTaskSet",
      "ecs:DeleteTaskSet",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:ModifyListener",
      "elasticloadbalancing:DescribeRules",
      "elasticloadbalancing:ModifyRule",
      "lambda:InvokeFunction",
      "cloudwatch:DescribeAlarms",
      "sns:Publish",
      "s3:GetObject",
      "s3:GetObjectVersion"
    ]
    resources = ["*"]
  }
}
