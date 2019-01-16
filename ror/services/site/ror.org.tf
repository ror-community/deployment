resource "aws_s3_bucket" "ror-org-s3" {
  # Unique name of the bucket in all of AWS
  bucket = "ror.org"

  # You want the files to be readable by anyone, since it's a website :)
  acl = "public-read"

  # A valid AWS region
  region = "eu-west-1"

  # We'll talk about this file in a moment
  policy = "${file("ror.org.s3.policy.json")}"

  # This tells AWS you want this S3 bucket to serve up a website
  website {
    # This tells AWS to use the file index.html if someone requests 
    # a directory like http://www.«your site».com/about/
    index_document = "index.html"
  }

  # This is the name of the S3 bucket where access logs will be
  # written.  We'll create this bucket in a moment
  logging {
    target_bucket = "${aws_s3_bucket.logs-ror-org-s3.id}"
    target_prefix = "root/"
  }

  # You can omit this if you like—tags can be helpful for managing
  # lots of stuff in AWS if you have to poke around the console
  tags {
    site        = "ror"
    environment = "production"
  }
}

## Logging bucket
resource "aws_s3_bucket" "logs-ror-org-s3" {
  bucket = "logs.ror.org"
  region = "eu-west-1"

  # Tells AWS to allow logs to be written here.
  # See https://docs.aws.amazon.com/AmazonS3/latest/dev/acl-overview.html
  acl = "log-delivery-write"

  tags {
    site        = "ror"
    environment = "production"
  }
}

# This is a _data source_ which allows us to get the internal
# ID (which AWS calls an "ARN") from AWS
data "aws_acm_certificate" "ror-org" {
  domain   = "ror.org"
  statuses = ["ISSUED"]
}

# Setup cloudfront, only for ror.c ommunity & www.ror.org 
resource "aws_cloudfront_distribution" "ror-org-cf_distribution" {
  # This says where CloudFront should get the data it's caching
  origin {
    # CloudFront can front any website, so in our case, we use the website from
    # our S3 bucket.
    domain_name = "${aws_s3_bucket.ror-org-s3.website_endpoint}"

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

  # This allows us to save CloudFront logs to our existing S3 bucket for logging
  # above
  logging_config {
    include_cookies = false
    bucket          = "${aws_s3_bucket.logs-ror-org-s3.bucket_domain_name}"

    # Inside the bucket, the CloudFront logs will be in the cf/ directory
    prefix = "cf/"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # This configures our SSL certificate.
  viewer_certificate {
    # The data source we set up above allows us to access the AWS internal ID (ARN) like so
    acm_certificate_arn      = "${data.aws_acm_certificate.ror-org.arn}"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1"
  }
}
