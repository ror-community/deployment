module "iam_account" {
  source = "terraform-aws-modules/iam/aws//modules/iam-account"

  account_alias = "${var.account_alias}"

  minimum_password_length = "${var.minimum_password_length}"
  require_numbers         = "${var.require_numbers}"
}

module "iam_assumable_roles" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-roles"

  trusted_role_arns = "${var.trusted_role_arns}"

  create_admin_role = "${var.create_admin_role}"

  create_poweruser_role = "${var.create_poweruser_role}"
  poweruser_role_name   = "${var.poweruser_role_name}"

  create_readonly_role       = "${var.create_readonly_role}"
  readonly_role_requires_mfa = "${var.readonly_role_requires_mfa}"
}

module "iam_user" {
  source = "terraform-aws-modules/iam/aws//modules/iam-user"

  name          = "${var.iam_user_name}"
  force_destroy = "${var.iam_user_force_destroy}"
  password_reset_required = "${var.iam_user_password_reset_required}"
}