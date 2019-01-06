module "eks" {
  source                = "terraform-aws-modules/eks/aws"
  
  cluster_name          = "${var.cluster_name}"
  subnets               = "${var.private_subnets}"
  vpc_id                = "${var.vpc_id}"
}