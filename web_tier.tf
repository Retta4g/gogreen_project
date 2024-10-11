# Application Load Balancer
resource "aws_lb" "app_lb" {
  name               = "app-lb"
  load_balancer_type = "application"
  internal           = true
  security_groups    = [aws_security_group.web_sg.id]
  subnets            = aws_subnet.public_subnet[*].id  # Reference both public subnets
  depends_on         = [aws_internet_gateway.igw_vpc]
}

# Target Group for EC2 Instances
resource "aws_lb_target_group" "alb_ec2_tg" {
  name     = "web-server-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.go_green_vpc.id

  tags = {
    Name = "alb_ec2_target"
  }
}

# Listener for ALB
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_ec2_tg.arn
  }

  tags = {
    Name = "alb_ec2_listener"
  }
}

# Launch Template for EC2 Instances (Web Tier)
resource "aws_launch_template" "ec2_launch_template" {
  name = "web-server"

  image_id      = "ami-047d7c33f6e7b4bc4"  # Replace with your desired AMI ID
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.web_sg.id]
  }

  # Updated UserData script for the Web and App tiers
  user_data = base64encode(<<-EOF
              #!/bin/bash -ex

              # Log everything to /var/log/user_data.log
              exec > >(tee /var/log/user_data.log|logger -t user-data -s 2>/dev/console) 2>&1

              # Update the system
              sudo yum update -y

              # Install Apache and PHP
              sudo yum install -y httpd php

              # Start and enable Apache
              sudo systemctl start httpd
              sudo systemctl enable httpd

              # Download and extract the sample application
              cd /var/www/html
              sudo wget https://aws-tc-largeobjects.s3-us-west-2.amazonaws.com/CUR-TF-200-ACACAD/studentdownload/lab-app.tgz
              sudo tar xvfz lab-app.tgz
              sudo chown apache:root /var/www/html/rds.conf.php

              # Replace sample HTML page
              echo "<h1>Hello world from GoGreen App Tier</h1>" > /var/www/html/index.html

              # Cleanup
              sudo rm -f lab-app.tgz

              # Restart Apache to apply all changes
              sudo systemctl restart httpd
              EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "ec2-web-server"
    }
  }
}

# Autoscaling Group for EC2 Instances (Web Tier)
resource "aws_autoscaling_group" "ec2_asg" {
  max_size            = 6
  min_size            = 2
  desired_capacity    = 2
  name                = "web-server-asg"
  target_group_arns   = [aws_lb_target_group.alb_ec2_tg.arn]
  vpc_zone_identifier = aws_subnet.public_subnet[*].id

  launch_template {
    id      = aws_launch_template.ec2_launch_template.id
    version = "$Latest"
  }

  health_check_type = "EC2"
  depends_on        = [aws_launch_template.ec2_launch_template, aws_lb.app_lb]
}

# Output for ALB DNS Name
output "alb_dns_name" {
  value = aws_lb.app_lb.dns_name
}
