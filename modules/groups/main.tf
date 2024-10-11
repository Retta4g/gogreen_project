resource "aws_iam_group" "groups" {
  for_each = var.groups

  name = each.key
}

resource "aws_iam_group_policy_attachment" "attach_group_policies" {
  for_each = var.groups

  group      = aws_iam_group.groups[each.key].name

  policy_arn = lookup({
    SysAdmin  = var.admin_policy_arn,
    DBAdmin   = var.dbadmin_policy_arn,
    Monitor   = var.monitor_policy_arn
  }, each.key, null)

  # Ensure the group is created before attaching the policy
  depends_on = [aws_iam_group.groups]
}