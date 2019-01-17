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

# variable "elastic_search" {
#   default = "http://elasticsearch.ror.org:80"
# }

# variable "es_name" {
#   default = "es"
# }

variable "ror-reconcile_tags" {
  type = "map"
}

variable "public_key" {}
# variable "bugsnag_key" {}

variable "aws_service_discovery_private_dns_namespace_id" {}
