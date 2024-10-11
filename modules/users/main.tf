resource "aws_iam_user" "users" {
  for_each = toset(var.user_names)

  name          = each.value
  path          = "/"
  force_destroy = true

  tags = {
    Name = each.value
  }
}

resource "aws_iam_user_login_profile" "user_login" {
  for_each = toset(var.user_names)

  user                    = each.value
  password_reset_required = true
  password_length         = 16

  # lifecycle {
  #   prevent_destroy = true
  # }

  depends_on = [aws_iam_user.users]
}

resource "aws_iam_access_key" "user_access_key" {
  for_each = toset(var.user_names)

  user    = each.value
  pgp_key = "" # Add PGP key here for access key encryption

  depends_on = [aws_iam_user.users]
}