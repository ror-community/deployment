variable "access_key" {}
variable "secret_key" {}
variable "region" {
    default = "eu-west-1"
}

variable "account_alias" {}
variable "minimum_password_length" {}
variable "require_numbers" {}

variable "trusted_role_arns" {
    type = "list"
}
variable "create_admin_role" {
    default = true
}
variable "create_poweruser_role" {
    default = true
}
variable "poweruser_role_name" {
    default = "developer"
}
variable "create_readonly_role" {
    default = true
}
variable "readonly_role_requires_mfa" {
    default = false
}

variable "iam_user_name" {}
variable "iam_user_force_destroy" {
    default = true
}
variable "iam_user_password_reset_required" {
    default = false
}