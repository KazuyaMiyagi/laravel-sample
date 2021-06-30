resource "aws_secretsmanager_secret" "dockerhub" {
  name                    = "/CodeBuild/DockerHubCredential"
  description             = "Docker Hub login credentials.  see https://docs.docker.com/docker-hub/access-tokens/"
  recovery_window_in_days = 30
}

resource "aws_secretsmanager_secret_version" "dockerhub" {
  secret_id = aws_secretsmanager_secret.dockerhub.id
  secret_string = jsonencode({
    USERNAME = var.dockerhub_username
    PASSWORD = var.dockerhub_password
  })
}

resource "aws_secretsmanager_secret" "github" {
  name                    = "/CodeBuild/GitHubCredential"
  description             = "GitHub login credentials.  see https://docs.github.com/en/github/authenticating-to-github/keeping-your-account-and-data-secure/creating-a-personal-access-token#creating-a-token"
  recovery_window_in_days = 30
}

resource "aws_secretsmanager_secret_version" "github" {
  secret_id     = aws_secretsmanager_secret.github.id
  secret_string = var.github_token
}

resource "aws_secretsmanager_secret" "main" {
  name                    = "/ECS/${title(var.application)}"
  description             = "${title(var.application)} Environment data."
  recovery_window_in_days = 30
}
