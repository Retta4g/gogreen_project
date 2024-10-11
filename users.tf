# Define variables for user names, groups, and policies

variable "user_names" {
  description = "List of IAM users"
  type        = list(string)
}

variable "groups" {
  description = "Map of IAM groups to be created"
  type        = map(list(string))
}

variable "admin_policy_arn" {
  description = "ARN of the admin policy for SysAdmin group"
  type        = string
}

variable "dbadmin_policy_arn" {
  description = "ARN of the policy for DBAdmin group with full access to databases and RDS"
  type        = string
}

variable "monitor_policy_arn" {
  description = "ARN of the policy for Monitor group with read-only access"
  type        = string
}

variable "ec2_to_s3_role_policy" {
  description = "Policy configuration for EC2 role to access S3"
  type = object({
    role_name = string
    policy = object({
      version = string
      statement = list(object({
        effect   = string
        action   = list(string)
        resource = string
      }))
    })
  })
}

variable "password_policy" {
  description = "Password policy configuration"
  type = object({
    minimum_password_length        = number
    require_symbols                = bool
    require_numbers                = bool
    require_uppercase_characters   = bool
    require_lowercase_characters    = bool
    allow_users_to_change_password = bool
    hard_expiry                    = bool
    password_reuse_prevention      = number
    max_password_age               = number
  })
}

variable "user_passwords" {
  description = "User-defined passwords for login profiles"
  type = map(string)
  default = {
    sysadmin1 = "some-random-password1"
    sysadmin2 = "some-random-password2"
    monitoruser1  = "some-random-password3"
    monitoruser2  = "some-random-password4"
    monitoruser3  = "some-random-password5"
    monitoruser4  = "some-random-password6"
    dbadmin1  = "some-random-password7"
    dbadmin2  = "some-random-password8"
  }
}
