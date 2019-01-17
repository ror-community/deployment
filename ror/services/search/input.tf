provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
  version    = "~> 1.6"
}

data "template_file" "search" {
  template = "${file("s3_cloudfront.json")}"

  vars {
    bucket_name = "search.ror.org"
  }
}
