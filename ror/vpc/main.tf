module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.vpc_name}"
  cidr = "${var.vpc_cidr}"

  azs             = "${var.azs}"
  private_subnets = "${var.private_subnets}"
  public_subnets  = "${var.public_subnets}"

  enable_nat_gateway = true
  enable_vpn_gateway = true

  vpc_tags = "${
    map(
     "kubernetes.io/cluster/${var.cluster_name}", "shared",
    )
  }"

  private_subnet_tags = "${
    map(
     "kubernetes.io/cluster/${var.cluster_name}", "shared",
    )
  }"

  tags = {
    Terraform = "true"
  }
}