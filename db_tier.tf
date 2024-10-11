# Private Subnet for DB Tier
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.go_green_vpc.id
  cidr_block        = "10.0.7.0/24"        # Unique CIDR for private subnet 1
  availability_zone = "us-west-1a"
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.go_green_vpc.id
  cidr_block        = "10.0.8.0/24"        # Unique CIDR for private subnet 2
  availability_zone = "us-west-1b"
}

# DB Subnet Group
resource "aws_db_subnet_group" "go_green_db_subnet_group" {
  name       = "go-green-db-subnet-group"
  subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
}

# RDS Instance Configuration
resource "aws_db_instance" "primary_rds" {
  identifier              = "go-green-primary-rds"
  allocated_storage       = 20
  storage_type            = "gp2"
  engine                  = "mysql"
  engine_version          = "8.0.34"
  instance_class          = "db.t3.micro"
  db_subnet_group_name    = aws_db_subnet_group.go_green_db_subnet_group.name
  username                = "admin"  # Static username

  # Reference the generated password stored in Secrets Manager
  password = jsondecode(aws_secretsmanager_secret_version.rds_password_version.secret_string)["password"]

  db_name                 = "gogreen_db"
  multi_az                = true
  backup_retention_period = 7
  backup_window           = "07:00-08:00"
  apply_immediately       = true
  skip_final_snapshot     = true

  tags = {
    Name = "go-green-primary-rds"
  }
}
