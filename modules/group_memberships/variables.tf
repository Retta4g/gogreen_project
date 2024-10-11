variable "groups" {
  description = "Map of IAM groups to users"
  type        = map(list(string))
}

variable "user_names" {
  description = "List of user names"
  type        = list(string)
}