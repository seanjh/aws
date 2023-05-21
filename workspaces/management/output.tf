output "blog_account_id" {
  description = "AWS account ID for the blog app"
  value       = aws_organizations_account.blog.id
}
