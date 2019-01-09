module "alb" {
  source                        = "terraform-aws-modules/alb/aws"

  load_balancer_name            = "alb"
  security_groups               = "${var.security_group_ids}"
  log_bucket_name               = "${aws_s3_bucket.logs.bucket}"
  log_location_prefix           = "alb-logs"
  subnets                       = "${var.private_subnet_ids}"
  tags                          = "${map("Environment", "production")}"
  vpc_id                        = "${var.vpc_id}"
}

resource "aws_s3_bucket" "logs" {
  bucket = "logs.ror.org"
  acl    = "private"
  policy = "${data.template_file.logs.rendered}"
  tags {
      Name = "ror"
  }
}

resource "aws_lb_listener" "alb-http" {
  load_balancer_arn = "${aws_lb.alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "alb" {
  load_balancer_arn = "${data.aws_lb.alb.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${data.aws_acm_certificate.ror.arn}"

  default_action {
    target_group_arn = "${data.aws_lb_target_group.api.id}"
    type             = "forward"
  }
}
