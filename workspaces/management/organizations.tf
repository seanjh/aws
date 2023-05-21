resource "aws_organizations_account" "blog" {
  name  = "blog"
  email = "seanjh+blog@hey.com"

  close_on_deletion = true
}
