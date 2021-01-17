resource "aws_lb" "main" {
  name               = "main"
  load_balancer_type = "application"
  internal           = false

  subnets = [
    aws_subnet.public_0.id,
    aws_subnet.public_1.id
  ]

  security_groups = [
    aws_security_group.lb.id
  ]

  access_logs {
    bucket  = aws_s3_bucket.lb.id
    enabled = true
  }
}

resource "aws_lb_target_group" "blue" {
  name        = "blue"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.main.id

  health_check {
    path    = "/"
    matcher = "200"
  }

  depends_on = [
    aws_lb.main
  ]
}

resource "aws_lb_target_group" "green" {
  name        = "green"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.main.id

  health_check {
    path    = "/"
    matcher = "200"
  }

  depends_on = [
    aws_lb.main
  ]
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn
    # TODO デフォルト400 のケース
    #  type = "fixed-response"
    #  fixed_response {
    #    content_type = "text/plain"
    #    message_body = "Bad Request"
    #    status_code  = 400
    #  }
  }
}
