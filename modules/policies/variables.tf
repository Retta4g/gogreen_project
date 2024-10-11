variable "password_policy" {
  description = "Password policy configuration"
  type = object({
    require_uppercase_characters = bool
    require_lowercase_characters = bool
    require_numbers              = bool
    require_symbols              = bool
    max_password_age             = number
    password_reuse_prevention    = number
  })
}