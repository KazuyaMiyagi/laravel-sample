resource "aws_s3_bucket" "lb" {
  bucket        = "lb-${data.aws_caller_identity.current.account_id}"
  acl           = "private"
  force_destroy = true

  lifecycle_rule {
    enabled = true
    expiration {
      days = 180
    }
  }
}

resource "aws_s3_bucket_public_access_block" "lb" {
  bucket                  = aws_s3_bucket.lb.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "lb" {
  statement {
    effect = "Allow"

    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.lb.arn}/*"
    ]

    principals {
      type = "AWS"
      identifiers = [
        data.aws_elb_service_account.main.arn
      ]
    }
  }
}

resource "aws_s3_bucket_policy" "lb" {
  bucket = aws_s3_bucket.lb.id
  policy = data.aws_iam_policy_document.lb.json
}

# CodeBuild and CodePipeline bucket

resource "aws_s3_bucket" "developer_tools" {
  bucket        = "developer-tools-bucket-${data.aws_caller_identity.current.account_id}"
  force_destroy = true

  lifecycle_rule {
    enabled = true

    expiration {
      days = 180
    }
  }
}

resource "aws_s3_bucket_public_access_block" "developer_tools" {
  bucket                  = aws_s3_bucket.developer_tools.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
