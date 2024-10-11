# modules/users/outputs.tf
output "created_users" {
  description = "The created IAM users"
  value = { for user, user_obj in aws_iam_user.users : user => user_obj.name }
}


