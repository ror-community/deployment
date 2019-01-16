resource "aws_s3_bucket" "staging-ror-org-s3" {
  bucket = "staging.ror.org"
  acl = "public-read"
  policy = "${data.template_file.site-staging.rendered}"

  website {
    index_document = "index.html"
  }

  tags {
    site        = "ror"
    environment = "staging"
  }
}

resource "aws_route53_record" "site-staging" {
  zone_id = "${data.aws_route53_zone.public.zone_id}"
  name = "staging.ror.org"
  type = "A"

  alias {
    name = "${data.aws_s3_bucket.staging-ror-org-s3.dns_name}"
    zone_id = "${data.aws_s3_bucket.staging-ror-org-s3.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "split-site-staging" {
  zone_id = "${data.aws_route53_zone.internal.zone_id}"
  name = "staging.ror.org"
  type = "A"

  alias {
    name = "${data.aws_s3_bucket.staging-ror-org-s3.dns_name}"
    zone_id = "${data.aws_s3_bucket.staging-ror-org-s3.zone_id}"
    evaluate_target_health = true
  }
}
