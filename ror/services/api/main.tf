resource "aws_ecs_service" "api" {
  name = "api"
  cluster = "${data.aws_ecs_cluster.default.id}"
  launch_type = "FARGATE"
  task_definition = "${aws_ecs_task_definition.api.arn}"
  desired_count = 2

  network_configuration {
    security_groups = ["${var.private_security_group_id}"]
    subnets         = ["${var.private_subnet_ids}"]
  }

  load_balancer {
    target_group_arn = "${aws_lb_target_group.api.id}"
    container_name   = "api"
    container_port   = "80"
  }

  depends_on = [
    "data.aws_lb_listener.default",
  ]
}

resource "aws_lb_target_group" "api" {
  name     = "api"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
  target_type = "ip"

  stickiness {
    type   = "lb_cookie"
  }
}

resource "aws_cloudwatch_log_group" "api" {
  name = "/ecs/api"
}

resource "aws_ecs_task_definition" "api" {
  family = "api"
  execution_role_arn = "${data.aws_iam_role.ecs_task_execution_role.arn}",
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu = "1024"
  memory = "2048"

  container_definitions =  "${data.template_file.api_task.rendered}"
}

resource "aws_route53_record" "api" {
    zone_id = "${data.aws_route53_zone.public.zone_id}"
    name = "api.ror.org"
    type = "CNAME"
    ttl = "${var.ttl}"
    records = ["${data.aws_lb.default.dns_name}"]
}

resource "aws_route53_record" "split-api" {
    zone_id = "${data.aws_route53_zone.internal.zone_id}"
    name = "api.ror.org"
    type = "CNAME"
    ttl = "${var.ttl}"
    records = ["${data.aws_lb.default.dns_name}"]
}
