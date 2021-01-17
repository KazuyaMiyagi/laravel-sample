resource "aws_secretsmanager_secret" "codebuild_dockerhubcredential" {
  name                    = "/CodeBuild/DockerHubCredential"
  description             = "Docker Hub login credentials.  see https://docs.docker.com/docker-hub/access-tokens/"
  recovery_window_in_days = 30
}

resource "aws_secretsmanager_secret" "laravel" {
  name                    = "/ECS/Laravel"
  description             = "Laravel Environment data."
  recovery_window_in_days = 30
}
