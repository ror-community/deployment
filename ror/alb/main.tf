module "alb" {
  source                        = "terraform-aws-modules/alb/aws"

  load_balancer_name            = "alb"
  security_groups               = "${var.security_group_ids}"
  log_bucket_name               = "${aws_s3_bucket.logs.bucket}"
  log_location_prefix           = "alb-logs"
  subnets                       = "${var.private_subnet_ids}"
  tags                          = "${map("Environment", "production")}"
  vpc_id                        = "${var.vpc_id}"
  https_listeners               = "${list(map("certificate_arn", var.certificate_arn, "port", 443))}"
  https_listeners_count         = "1"
  http_tcp_listeners            = "${list(map("port", "80", "protocol", "HTTP"))}"
  http_tcp_listeners_count      = "1"
  target_groups                 = "${list(map("name", "foo", "backend_protocol", "HTTP", "backend_port", "80"))}"
  target_groups_count           = "1"
}

resource "aws_s3_bucket" "logs" {
  bucket = "logs.ror.org"
  acl    = "private"
  policy = "${data.template_file.logs.rendered}"
  tags {
      Name = "ror"
  }
}
