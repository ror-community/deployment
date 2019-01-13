resource "aws_s3_bucket" "app" {
    bucket = "app.ror.org"
    acl = "public-read"
    policy = "${data.template_file.app.rendered}"
    website {
        index_document = "index.html"
    }
    tags {
        Name = "app"
    }
    versioning {
        enabled = true
    }
}

resource "aws_cloudfront_origin_access_identity" "app_ror_org" {}

resource "aws_cloudfront_distribution" "app" {
  origin {
    domain_name = "${aws_s3_bucket.app.bucket_domain_name}"
    origin_id   = "app.ror.org"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.app_ror_org.cloudfront_access_identity_path}"
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  logging_config {
    include_cookies = false
    bucket          = "${data.aws_s3_bucket.logs.bucket_domain_name}"
    prefix          = "app/"
  }

  aliases = ["app.ror.org"]

  custom_error_response {
    error_code            = "404"
    error_caching_min_ttl = "5"
    response_code         = "200"
    response_page_path    = "/index.html"
  }

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "app.ror.org"

    forwarded_values {
      query_string = false
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags {
    Environment = "prod"
  }

  viewer_certificate {
    acm_certificate_arn = "${data.aws_acm_certificate.cloudfront.arn}"
    ssl_support_method  = "sni-only"
  }
}

resource "aws_route53_record" "app" {
  zone_id = "${data.aws_route53_zone.public.zone_id}"
  name = "app.ror.org"
  type = "CNAME"
  ttl = "${var.ttl}"
  records = ["${aws_cloudfront_distribution.app.domain_name}"]
}

resource "aws_route53_record" "split-doi" {
  zone_id = "${data.aws_route53_zone.internal.zone_id}"
  name = "app.ror.org"
  type = "CNAME"
  ttl = "${var.ttl}"
  records = ["${aws_cloudfront_distribution.app.domain_name}"]
}
