# Private Subnet Definition (No Overlapping CIDR Blocks)
resource "aws_subnet" "private_subnet" {
  count             = length(var.private_subnet_cidr_blocks)
  vpc_id            = aws_vpc.go_green_vpc.id
  cidr_block        = element(var.private_subnet_cidr_blocks, count.index)
  availability_zone = element(var.vpc_availability_zones, count.index)
 
  tags = {
    Name = "GoGreen-Private-Subnet-${count.index + 1}"
  }
}
# Variable for Private Subnets CIDR Blocks
variable "private_subnet_cidr_blocks" {
  description = "List of CIDR blocks for private subnets."
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"] # Ensure non-overlapping CIDR blocks
}

# Launch Template for App Tier
resource "aws_launch_template" "app" {
  name_prefix   = "app-tier-"
  image_id      = "ami-047d7c33f6e7b4bc4"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.app_sg.id]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "GoGreen-App-Instance"
  }
}

# Auto Scaling Group for App Tier
resource "aws_autoscaling_group" "app_asg" {
  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  min_size         = 2
  max_size         = 6
  desired_capacity = 2

  vpc_zone_identifier = aws_subnet.private_subnet[*].id

  health_check_type         = "ELB"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "GoGreen-App-Instance"
    propagate_at_launch = true
  }
}

# Application Load Balancer (ALB) for App Tier
resource "aws_lb" "app_alb" {
  name               = "go-green-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.app_elb_sg.id]
  subnets            = aws_subnet.private_subnet[*].id

  enable_deletion_protection = false

  tags = {
    Name = "GoGreen-App-ALB"
  }
}

# Target Group for App Instances
resource "aws_lb_target_group" "app_tg" {
  name        = "go-green-app-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = aws_vpc.go_green_vpc.id

  health_check {
    protocol = "HTTP"
    path     = "/"
  }

  tags = {
    Name = "GoGreen-App-TG"
  }
}

# Listener for the Application Load Balancer
resource "aws_lb_listener" "app_alb_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

# Register the App Instances with the Target Group
resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.app_asg.name
  lb_target_group_arn    = aws_lb_target_group.app_tg.arn
}
