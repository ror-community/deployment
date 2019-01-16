resource "aws_s3_bucket" "ror-org-s3" {
  bucket = "ror.org"
  acl = "public-read"
  policy = "${data.template_file.site.rendered}"

  website {
    index_document = "index.html"

    routing_rules = <<EOF
[{
    "Condition": {
        "HttpErrorCodeReturnedEquals": "404"
    },
    "Redirect": {
        "Hostname": "api.ror.org",
        "HttpRedirectCode": "302",
        "Protocol": "https"
    }
}]
EOF
  }

  tags {
    site        = "ror"
    environment = "production"
  }
}

resource "aws_cloudfront_distribution" "ror-org-cf_distribution" {
  origin {
    domain_name = "${aws_s3_bucket.ror-org-s3.bucket_domain_name}"

    origin_id = "${aws_s3_bucket.ror-org-s3.bucket_domain_name}"

    # This allows requests for / to serve up /index.html which cloudfront won't do
    # There is a simpler configuration that doesn't require this, but it won't translate
    # a request for / to one for /index.html  This is what enables that to work
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["SSLv3", "TLSv1"]
    }
  }

  tags {
    site        = "ror"
    environment = "production"
  }

  aliases             = ["ror.org", "www.ror.org"]
  default_root_object = "index.html"
  enabled             = "true"

  # You can override this per object, but for our purposes, this is fine for everything
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${aws_s3_bucket.ror-org-s3.bucket_domain_name}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    # This says to redirect http to https
    viewer_protocol_policy = "redirect-to-https"
    compress               = "true"
    min_ttl                = 0

    # default cache time in seconds.  This is 1 day, meaning CloudFront will only
    # look at your S3 bucket for changes once per day.
    default_ttl = 86400

    max_ttl = 604800
  }

  logging_config {
    include_cookies = false
    bucket          = "${data.aws_s3_bucket.logs.bucket_domain_name}"

    prefix = "cf/"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = "${data.aws_acm_certificate.cloudfront.arn}"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1"
  }
}

resource "aws_route53_record" "www" {
   zone_id = "${data.aws_route53_zone.public.zone_id}"
   name = "www.ror.org"
   type = "A"

   alias {
     name = "${aws_cloudfront_distribution.ror-org-cf_distribution.domain_name}"
     zone_id = "${aws_cloudfront_distribution.ror-org-cf_distribution.hosted_zone_id}"
     evaluate_target_health = true
   }
}
