terraform {
  required_version = ">= 1.55"

  backend "atlas" {
    name         = "datacite-ng/ror-services-api"
  }
}