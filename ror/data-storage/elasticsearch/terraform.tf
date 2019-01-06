terraform {
  required_version = ">= 0.11"

  backend "atlas" {
    name         = "datacite-ng/ror-data-storage-elasticsearch"
  }
}
