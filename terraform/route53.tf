data "aws_route53_zone" "ancestor" {
  name = var.ancestor_domain_name
}

resource "aws_route53_record" "ancestor_ns" {
  zone_id = data.aws_route53_zone.ancestor.zone_id
  name    = var.domain_name
  type    = "NS"
  records = aws_route53_zone.main.name_servers
  ttl     = 300
}

resource "aws_route53_zone" "main" {
  name          = var.domain_name
  comment       = "DNS Zone for ${var.domain_name}"
  force_destroy = "false"
}

resource "aws_route53_record" "www" {
  zone_id         = aws_route53_zone.main.zone_id
  name            = "www"
  type            = "A"
  allow_overwrite = "true"

  alias {
    name                   = aws_lb.main.dns_name
    zone_id                = aws_lb.main.zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "echo" {
  zone_id         = aws_route53_zone.main.zone_id
  name            = "echo"
  type            = "A"
  allow_overwrite = "true"

  alias {
    name                   = aws_lb.main.dns_name
    zone_id                = aws_lb.main.zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "cert" {
  for_each = {
    for dvo in aws_acm_certificate.main.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  name            = each.value.name
  records         = [each.value.record]
  type            = each.value.type
  zone_id         = aws_route53_zone.main.zone_id
  ttl             = 300
  allow_overwrite = true
}
