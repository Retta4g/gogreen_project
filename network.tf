# VPC Definition
resource "aws_vpc" "go_green_vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "GoGreen-VPC"
  }
}

# Public Subnets Definition (No Overlapping CIDR Blocks)
resource "aws_subnet" "public_subnet" {
  count             = 2
  vpc_id            = aws_vpc.go_green_vpc.id
  cidr_block        = element(var.public_subnet_cidr_blocks, count.index)
  availability_zone = element(var.vpc_availability_zones, count.index)

  tags = {
    Name = "GoGreen-Public-Subnet-${count.index + 1}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw_vpc" {
  vpc_id = aws_vpc.go_green_vpc.id

  tags = {
    Name = "ig"
  }
}

# Route Table
resource "aws_route_table" "custom" {
  vpc_id = aws_vpc.go_green_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_vpc.id
  }

  tags = {
    Name = "Public subnet route table"
  }
}

# Route Table Association with Subnets
resource "aws_route_table_association" "PSA" {
  count          = length(var.vpc_availability_zones)
  route_table_id = aws_route_table.custom.id
  subnet_id      = element(aws_subnet.public_subnet[*].id, count.index)
}

# Elastic IP
resource "aws_eip" "eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.igw_vpc]
}

# Variables for VPC and Subnets
variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_availability_zones" {
  type        = list(string)
  description = "Availability zones"
  default     = ["us-west-1a", "us-west-1b"]
}

variable "public_subnet_cidr_blocks" {
  description = "CIDR blocks for public subnets."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

# Outputs for VPC and CIDR block
output "vpc_id" {
  description = "The ID of the created VPC"
  value       = aws_vpc.go_green_vpc.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the created VPC"
  value       = aws_vpc.go_green_vpc.cidr_block
}
