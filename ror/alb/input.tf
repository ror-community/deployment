provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
  version    = "~> 1.6"
}

data "template_file" "logs" {
  template = "${file("s3_write_access.json")}"

  vars {
    bucket_name = "logs.ror.org"
  }
}
