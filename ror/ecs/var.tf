variable "access_key" {}
variable "secret_key" {}
variable "region" {
    default = "eu-west-1"
}

variable "vpc_id" {}
variable "private_subnet_ids" {
    type = "list"
}
