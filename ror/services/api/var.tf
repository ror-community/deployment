variable "access_key" {}
variable "secret_key" {}
variable "region" {
    default = "eu-west-1"
}

variable "ttl" {
  default = "300"
}

variable "vpc_id" {}
variable "private_subnet_ids" {
    type = "list"
}
variable "private_security_group_id" {}

variable "elastic_search" {
  default = "http://elasticsearch.ror.org:80"
}
variable "es_name" {
  default = "es"
}
variable "ror-api_tags" {
  type = "map"
}

variable "public_key" {}
variable "bugsnag_key" {}
