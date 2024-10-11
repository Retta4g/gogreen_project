resource "aws_iam_account_password_policy" "password_policy" {
  minimum_password_length    = 12
  require_uppercase_characters = var.password_policy.require_uppercase_characters
  require_lowercase_characters = var.password_policy.require_lowercase_characters
  require_numbers            = var.password_policy.require_numbers
  require_symbols            = var.password_policy.require_symbols
  max_password_age           = var.password_policy.max_password_age
  password_reuse_prevention  = var.password_policy.password_reuse_prevention
  allow_users_to_change_password = true
}