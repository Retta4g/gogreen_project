# List of IAM users to be created
user_names = [
  "sysadmin1",
  "sysadmin2",
  "dbadmin1",
  "dbadmin2",
  "monitoruser1",
  "monitoruser2",
  "monitoruser3",
  "monitoruser4"
]

# Map of IAM groups to be created with the list of users in each group
groups = {
  # System Administrator Group with Administrator access
  "SysAdmin" = ["sysadmin1", "sysadmin2"] 

  # Database Administrator Group with full access to databases and RDS
  "DBAdmin"  = ["dbadmin1", "dbadmin2"]   

  # Monitoring Group with read-only access to monitor infrastructure resources
  "Monitor"  = ["monitoruser1", "monitoruser2", "monitoruser3", "monitoruser4"]
}

# ARN of the admin policy for SysAdmin (Full Administrator access)
admin_policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"

# ARN of the policy for DBAdmin group to have Full access to RDS/Databases
dbadmin_policy_arn = "arn:aws:iam::aws:policy/AmazonRDSDataFullAccess"

# ARN of the policy for Monitor group to have read-only access for monitoring resources
monitor_policy_arn = "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"

# IAM role for EC2 with permissions to get and put objects in S3
ec2_to_s3_role_policy = {
  role_name = "EC2toS3IAMRole"
  policy = {
    version = "2012-10-17"
    statement = [
      {
        effect = "Allow"
        action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        resource = "arn:aws:s3:::your-s3-bucket-name/*" # Replace with your actual bucket ARN
      }
    ]
  }
}

# Password policy configuration
password_policy = {
  minimum_password_length           = 12
  require_symbols                   = true
  require_numbers                   = true
  require_uppercase_characters      = true
  require_lowercase_characters      = true
  allow_users_to_change_password    = true
  hard_expiry                       = true # Forces password change every 90 days
  password_reuse_prevention         = 3    # Prevents re-use of last 3 passwords
  max_password_age                  = 90   # Password validity in days
}
