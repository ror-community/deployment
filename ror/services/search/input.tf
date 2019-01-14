provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

provider "aws" {
  # us-east-1 region
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "us-east-1"
  alias = "use1"
}

data "template_file" "search" {
  template = "${file("s3_cloudfront.json")}"

  vars {
    bucket_name = "search.ror.org"
  }
}

data "aws_acm_certificate" "cloudfront" {
  provider = "aws.use1"
  domain = "*.ror.org"
  statuses = ["ISSUED"]
}

data "aws_route53_zone" "public" {
  name         = "ror.org"
}

data "aws_route53_zone" "internal" {
  name         = "ror.org"
  private_zone = true
}

data "aws_s3_bucket" "logs" {
  bucket = "logs.ror.org"
}
