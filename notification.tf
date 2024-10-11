# Web-tier CloudWatch Alarm
resource "aws_cloudwatch_metric_alarm" "web_alarm" {
  alarm_name          = "web_instance_cpu_alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.ec2_asg.name
  }

  alarm_description = "Web instance CPU utilization alarm."
  actions_enabled   = true
  alarm_actions     = [aws_sns_topic.web_sns.arn]
}
# web tier that triggers when the average CPU utilization of EC2 instances in the associated Auto Scaling Group exceeds 80% 

# App-tier CloudWatch Alarm
resource "aws_cloudwatch_metric_alarm" "app_alarm" {
  alarm_name          = "app_instance_cpu_alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app_asg.name
  }

  alarm_description = "App instance CPU utilization alarm."
  actions_enabled   = true
  alarm_actions     = [aws_sns_topic.app_sns.arn]
}
#  triggers when the average CPU utilization of EC2 instances in its Auto Scaling Group exceeds 80% over two consecutive 5-minute periods

# SNS Topic for Web-tier Alarms
resource "aws_sns_topic" "web_sns" {
  name = "web-sns-topic"
}
# SNS topic named "web-sns-topic" for sending notifications related to the web tier alarms

# SNS Topic for App-tier Alarms
resource "aws_sns_topic" "app_sns" {
  name = "app-sns-topic"
}
# SNS topic named "app-sns-topic" for sending notifications related to the app tier alarms

# SNS Subscription for Web-tier Alarms
resource "aws_sns_topic_subscription" "web_sns_subscription" {
  topic_arn = aws_sns_topic.web_sns.arn
  protocol  = "email"
  endpoint  = "Mohina.shukurova@gmail.com"  # Replace with actual email address
}
# email endpoint to the web SNS topic so that notifications about web tier alarms

# SNS Subscription for App-tier Alarms
resource "aws_sns_topic_subscription" "app_sns_subscription" {
  topic_arn = aws_sns_topic.app_sns.arn
  protocol  = "email"
  endpoint  = "Mohina.shukurova@gmail.com"  # Replace with actual email address
}
# email endpoint to the app SNS topic to receive notifications about app tier alarms