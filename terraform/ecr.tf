resource "aws_ecr_repository" "main" {
  name = var.application

  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "main" {
  repository = aws_ecr_repository.main.name

  policy = <<-EOF
	{
	  "rules": [
	    {
	      "rulePriority": 1,
	      "description": "Delete untagged images",
	      "selection": {
	        "tagStatus": "untagged",
	        "countType": "sinceImagePushed",
	        "countUnit": "days",
	        "countNumber": 1
	      },
	      "action": {
	        "type": "expire"
	      }
	    }
	  ]
	}
	EOF
}
