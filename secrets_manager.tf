# Create a Secrets Manager secret for storing user credentials
resource "aws_secretsmanager_secret" "users" {
  name = "new-unique-secret-name07"
}

# Create a dynamic secret string that includes usernames and passwords for IAM users
resource "aws_secretsmanager_secret_version" "users" {
  secret_id = aws_secretsmanager_secret.users.id

  # Dynamically generate a secret string that combines the created users and their passwords
  secret_string = jsonencode({
    for username, name_value in module.iam_users.created_users :
    username => {
      username = name_value,
      password = var.user_passwords[username]  # Match password for the corresponding username
    }
  })
}

# Create a Secrets Manager secret specifically for RDS password
resource "aws_secretsmanager_secret" "rds_password_secret" {
  name        = "go-green-db-password-v7"  # Changed name to avoid conflict
  description = "Password for GoGreen RDS instance"
}

# Generate a random password for RDS and store it in Secrets Manager
resource "random_password" "rds_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*+-.:;<=>?_^"  # Valid characters for RDS password
}

resource "aws_secretsmanager_secret_version" "rds_password_version" {
  secret_id     = aws_secretsmanager_secret.rds_password_secret.id
  secret_string = jsonencode({
    username = "admin",                      # Static username for the RDS instance
    password = random_password.rds_password.result  # Automatically generated password
  })
}
