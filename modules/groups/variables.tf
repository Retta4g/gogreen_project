# Define variables for the policies and groups
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

variable "groups" {
  description = "Map of IAM groups to be created"
  type        = map(list(string))
}