#Bastion Host Security Group
resource "aws_security_group" "bastion_sg" {
  vpc_id      = aws_vpc.go_green_vpc.id
  description = "Security group for bastion host"

  ingress {
    from_port   = 22 # Used for secure remote access via SSH
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["208.86.66.240/32"]  # Your IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Web Security Group
resource "aws_security_group" "web_sg" {
  vpc_id      = aws_vpc.go_green_vpc.id
  description = "Security group for web"

  ingress {
    from_port   = 80 # Used for unencrypted web traffic (HTTP)
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443 # Used for encrypted web traffic (HTTPS)
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 22 # Used for secure remote access via SSH
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "app_sg" {
  vpc_id      = aws_vpc.go_green_vpc.id
  description = "Security group for app instances"

  ingress {
    from_port       = 8080 # used for HTTP traffic as an alternative to port 80
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  ingress {
    from_port       = 22 # Used for secure remote access via SSH
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app_elb_sg" {
  vpc_id      = aws_vpc.go_green_vpc.id
  description = "Security group for ALB"

  ingress {
    from_port       = 8080 # used for HTTP traffic as an alternative to port 80
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "db_sg" {
  vpc_id      = aws_vpc.go_green_vpc.id
  description = "Security group for database"

  ingress {
    from_port       = 3306 # Default port for MySQL database connections
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
