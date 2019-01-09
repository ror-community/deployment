module "ecs_fargate" { 
  source  = "blinkist/airship-ecs-cluster/aws"
  version = "0.5.0"

  name = "${var.cluster_name}"

  vpc_id = "${var.vpc_id}"
  subnet_ids = ["${var.private_subnet_ids}"]

  create_roles                    = false
  create_autoscalinggroup         = false
}
