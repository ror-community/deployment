provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
  version    = "~> 1.6"
}

data "terraform_remote_state" "vpc" {
  backend = "atlas"
  config {
    name = "ror/vpc"
  }
}

data "template_file" "logs" {
  template = "${file("s3_write_access.json")}"

  vars {
    bucket_name = "logs.ror.org"
  }
}

data "aws_lb" "alb" {
  name = "alb"
}

data "aws_lb_target_group" "api" {
  name = "api"
}

data "aws_acm_certificate" "ror" {
  domain = "*.ror.org"
  statuses = ["ISSUED"]
}
