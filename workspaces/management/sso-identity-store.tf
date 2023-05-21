##########
# Groups #
##########

resource "aws_identitystore_group" "admins" {
  display_name      = "admins"
  description       = "Full account administrators"
  identity_store_id = local.sso_identity_store_id
}

resource "aws_identitystore_group" "power_users" {
  display_name      = "power-users"
  description       = "Account power users"
  identity_store_id = local.sso_identity_store_id
}

resource "aws_identitystore_group" "read_only" {
  display_name      = "read-only"
  description       = "Read-only access users"
  identity_store_id = local.sso_identity_store_id
}


#########
# Users #
#########

resource "aws_identitystore_user" "sean" {
  identity_store_id = local.sso_identity_store_id

  display_name = "Sean Herman"
  user_name    = "sean"

  name {
    given_name  = "Sean"
    family_name = "Herman"
  }

  emails {
    value = "seanjh@hey.com"
  }
}

###############
# User Access #
###############

resource "aws_identitystore_group_membership" "sean_admin" {
  identity_store_id = local.sso_identity_store_id
  group_id          = aws_identitystore_group.admins.group_id
  member_id         = aws_identitystore_user.sean.user_id
}

resource "aws_identitystore_group_membership" "sean_power_user" {
  identity_store_id = local.sso_identity_store_id
  group_id          = aws_identitystore_group.power_users.group_id
  member_id         = aws_identitystore_user.sean.user_id
}

resource "aws_identitystore_group_membership" "sean_read_only" {
  identity_store_id = local.sso_identity_store_id
  group_id          = aws_identitystore_group.read_only.group_id
  member_id         = aws_identitystore_user.sean.user_id
}
