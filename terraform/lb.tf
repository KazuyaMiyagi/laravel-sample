resource "aws_lb" "main" {
  name               = var.application
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

resource "aws_lb_target_group" "blue-green" {
  count       = 2
  name        = "${var.application}-blue-green-${count.index}"
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

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.main.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.main.arn

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Bad Request"
      status_code  = 400
    }
  }
}

resource "aws_lb_listener_rule" "https" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue-green[0].arn
  }

  condition {
    host_header {
      values = ["www.${var.domain_name}"]
    }
  }

  # CodeDeploy automatically changes the target group
  lifecycle {
    ignore_changes = [action]
  }
}
