resource "aws_s3_bucket" "dev-ror-org-s3" {
  bucket = "dev.ror.org"
  acl = "public-read"
  policy = "${data.template_file.site-dev.rendered}"

  website {
    index_document = "index.html"
  }

  tags {
    site        = "ror"
    environment = "development"
  }
}

resource "aws_route53_record" "site-dev" {
  zone_id = "${data.aws_route53_zone.public.zone_id}"
  name = "dev.ror.org"
  type = "A"

  alias {
    name = "${data.aws_s3_bucket.dev-ror-org-s3.dns_name}"
    zone_id = "${data.aws_s3_bucket.dev-ror-org-s3.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "split-site-dev" {
  zone_id = "${data.aws_route53_zone.internal.zone_id}"
  name = "dev.ror.org"
  type = "A"

  alias {
    name = "${data.aws_s3_bucket.dev-ror-org-s3.dns_name}"
    zone_id = "${data.aws_s3_bucket.dev-ror-org-s3.zone_id}"
    evaluate_target_health = true
  }
}
