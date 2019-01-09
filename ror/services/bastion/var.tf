variable "access_key" {}
variable "secret_key" {}
variable "region" {
    default = "eu-west-1"
}
variable "vpc_id" {}

variable "ami" {
  type = "map"
  description = "Amazon Linux default AMI"

  default = {
    eu-west-1 = "ami-1a962263"
  }
}

variable "hostname" {}
variable "key_name" {}

variable "ttl" {
  default = "300"
}

variable "public_subnet_id" {}
