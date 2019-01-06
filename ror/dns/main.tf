resource "aws_route53_zone" "internal" {
    name = "ror.org"
    vpc_id  = "${var.vpc_id}"

    tags {
        Environment = "internal"
    }
}

resource "aws_route53_record" "internal-ns" {
    zone_id = "${aws_route53_zone.internal.zone_id}"
    name = "ror.org"
    type = "NS"
    ttl = "30"
    records = [
        "${aws_route53_zone.internal.name_servers.0}",
        "${aws_route53_zone.internal.name_servers.1}",
        "${aws_route53_zone.internal.name_servers.2}",
        "${aws_route53_zone.internal.name_servers.3}"
    ]
}
