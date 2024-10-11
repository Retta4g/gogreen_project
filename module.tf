# Call the groups module
module "iam_groups" {
  source           = "./modules/groups"
  groups           = var.groups
  admin_policy_arn = var.admin_policy_arn
  dbadmin_policy_arn = var.dbadmin_policy_arn
  monitor_policy_arn = var.monitor_policy_arn
}

# Call the group memberships module
module "group_memberships" {
  source     = "./modules/group_memberships"
  groups     = var.groups
  user_names = values(module.iam_users.created_users)  # Extract the values from the map

  # Ensure groups are created first
  depends_on = [module.iam_groups]
}

# Call the users module
module "iam_users" {
  source     = "./modules/users"  # Ensure the path is correct relative to your root module
  user_names = var.user_names
}