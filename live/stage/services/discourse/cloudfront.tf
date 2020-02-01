resource "aws_cloudfront_origin_access_identity" "uploads" {
  comment = "discourse-${local.environment} uploads origin"
}

resource "aws_cloudfront_distribution" "cdn" {
  origin {
    domain_name = aws_s3_bucket.uploads.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.uploads.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = ["${local.cdn_url}.${var.domain}"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Terraform   = true
    Name        = local.s3_origin_id
    Environment = var.environment
  }

  // We are using a custom alias
  // We need to provide a SSL certificate for that alias
  viewer_certificate {
    ssl_support_method  = "sni-only"
    acm_certificate_arn = data.aws_acm_certificate.domain.arn
  }
}

resource "aws_route53_record" "cdn" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = local.cdn_url
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cdn.domain_name
    zone_id                = aws_cloudfront_distribution.cdn.hosted_zone_id
    evaluate_target_health = false
  }
}
