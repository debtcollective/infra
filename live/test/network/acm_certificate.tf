// request ACM cetificate
resource "aws_acm_certificate" "cert" {
  domain_name               = "*.debtcollective.org"
  subject_alternative_names = ["debtcollective.org"]
  validation_method         = "DNS"

  tags = {
    Terraform   = true
    Environment = "test"
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_route53_zone" "debtcollective" {
  name         = "debtcollective.org"
  private_zone = false
}

// create route53 record for ACM certificate DNS validation
resource "aws_route53_record" "acm" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.debtcollective.zone_id
}

// create route53 record for ACM certificate DNS validation
resource "aws_acm_certificate_validation" "acm" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.acm : record.fqdn]
}
