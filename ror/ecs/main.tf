module "ecs_fargate" { 
  source  = "blinkist/airship-ecs-cluster/aws"
  version = "0.5.0"

  name = "${var.cluster_name}"

  vpc_id = "${var.vpc_id}"
  subnet_ids = ["${var.private_subnet_ids}"]

  create_roles                    = false
  create_autoscalinggroup         = false
}

resource "aws_iam_role" "ecs_tasks_execution_role" {
  name               = "ecs-task-execution-role"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_tasks_execution_role.json}"
}

resource "aws_iam_role_policy_attachment" "ecs_tasks_execution_role" {
  role       = "${aws_iam_role.ecs_tasks_execution_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
