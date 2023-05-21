data "aws_ssoadmin_instances" "sso" {}

locals {
  sso_identity_store_id = tolist(data.aws_ssoadmin_instances.sso.identity_store_ids)[0]
  sso_instance_arn      = tolist(data.aws_ssoadmin_instances.sso.arns)[0]
}

resource "aws_ssoadmin_permission_set" "admin" {
  name             = "AdministratorAccess"
  description      = "Provides full access to AWS services and resources."
  instance_arn     = local.sso_instance_arn
  session_duration = "PT1H"
}

resource "aws_ssoadmin_managed_policy_attachment" "admin" {
  instance_arn       = local.sso_instance_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  permission_set_arn = aws_ssoadmin_permission_set.admin.arn
}

resource "aws_ssoadmin_permission_set" "power_user" {
  name             = "PowerUserAccess"
  description      = "Provides full access to AWS services and resources, but does not allow management of Users and groups."
  instance_arn     = local.sso_instance_arn
  session_duration = "PT8H"
}

resource "aws_ssoadmin_managed_policy_attachment" "power_user" {
  instance_arn       = local.sso_instance_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
  permission_set_arn = aws_ssoadmin_permission_set.power_user.arn
}

resource "aws_ssoadmin_permission_set" "read_only" {
  name             = "ReadOnlyAccess"
  description      = "Provides read-only access to AWS services and resources."
  instance_arn     = local.sso_instance_arn
  session_duration = "PT8H"
}

resource "aws_ssoadmin_managed_policy_attachment" "read_only" {
  instance_arn       = local.sso_instance_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  permission_set_arn = aws_ssoadmin_permission_set.read_only.arn
}

########################
# Account Group Access #
########################

resource "aws_ssoadmin_account_assignment" "management_admin" {
  instance_arn       = local.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.admin.arn

  principal_id   = aws_identitystore_group.admins.group_id
  principal_type = "GROUP"

  target_id   = data.aws_caller_identity.current.account_id
  target_type = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "blog_power_user" {
  instance_arn       = local.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.power_user.arn

  principal_id   = aws_identitystore_group.power_users.group_id
  principal_type = "GROUP"

  target_id   = aws_organizations_account.blog.id
  target_type = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "blog_read_only" {
  instance_arn       = local.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.read_only.arn

  principal_id   = aws_identitystore_group.read_only.group_id
  principal_type = "GROUP"

  target_id   = aws_organizations_account.blog.id
  target_type = "AWS_ACCOUNT"
}
