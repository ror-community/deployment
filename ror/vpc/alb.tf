module "alb" {
  source                        = "terraform-aws-modules/alb/aws"
  version                       = "3.5.0"
  load_balancer_name            = "alb"
  security_groups               = ["${aws_security_group.lb_sg.id}"]
  log_bucket_name               = "${aws_s3_bucket.logs.bucket}"
  log_location_prefix           = "alb-logs"
  subnets                       = "${module.vpc.public_subnets}"
  tags                          = "${map("Environment", "production")}"
  vpc_id                        = "${module.vpc.vpc_id}"
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
  load_balancer_arn = "${module.alb.load_balancer_id}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${data.aws_lb_target_group.api.id}"
    type             = "forward"
  }
}

resource "aws_lb_listener" "alb" {
  load_balancer_arn = "${module.alb.load_balancer_id}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${data.aws_acm_certificate.ror.arn}"

  default_action {
    target_group_arn = "${data.aws_lb_target_group.api.id}"
    type             = "forward"
  }
}

resource "aws_lb_listener_rule" "redirect_www" {
  listener_arn = "${aws_lb_listener.alb.arn}"

  action {
    type = "redirect"

    redirect {
      host        = "ror.org"
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_302"
    }
  }

  condition {
    field  = "host-header"
    values = ["www.ror.org"]
  }
}

resource "aws_route53_record" "www" {
    zone_id = "${aws_route53_zone.public.zone_id}"
    name = "www.ror.org"
    type = "CNAME"
    ttl = "${var.ttl}"
    records = ["${data.aws_lb.alb.dns_name}"]
}
