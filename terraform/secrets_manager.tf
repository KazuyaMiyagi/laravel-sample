resource "aws_secretsmanager_secret" "dockerhub" {
  name                    = "/CodeBuild/DockerHubCredential"
  description             = "Docker Hub login credentials.  see https://docs.docker.com/docker-hub/access-tokens/"
  recovery_window_in_days = 30
}

resource "aws_secretsmanager_secret" "main" {
  name                    = "/ECS/${title(var.application)}"
  description             = "${title(var.application)} Environment data."
  recovery_window_in_days = 30
}
