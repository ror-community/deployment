variable "access_key" {}
variable "secret_key" {}
variable "region" {
    default = "eu-west-1"
}

variable "vpc_name" {}
variable "vpc_cidr" {}
variable "azs" {}
variable "private_subnets" {}
variable "public_subnets" {}
