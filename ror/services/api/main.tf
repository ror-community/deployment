resource "aws_route53_record" "api" {
    zone_id = "${data.aws_route53_zone.public.zone_id}"
    name = "api.ror.org"
    type = "CNAME"
    ttl = "${var.ttl}"
    records = ["${data.aws_lb.alb.dns_name}"]
}

resource "aws_route53_record" "split-api" {
    zone_id = "${data.aws_route53_zone.internal.zone_id}"
    name = "api.ror.org"
    type = "CNAME"
    ttl = "${var.ttl}"
    records = ["${data.aws_lb.alb.dns_name}"]
}
