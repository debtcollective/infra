variable "power_report_cloudfront_domain_name" {
  description = "cloudfront domain name"
}

variable "landing_cloudfront_domain_name" {
  description = "cloudfront domain name"
}

variable "landing_domain_name" {
  description = "landing domain name for CNAME record"
}

variable "landing_ip_address" {
  description = "landing ip adress for A record"
}

variable "cloudfront_zone_id" {
  description = "cloudfront zone id for route 53 alias"
}
