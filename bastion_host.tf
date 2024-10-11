resource "aws_instance" "bastion_host" {
  ami           = var.ami_id
  instance_type = var.instance_type
 
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  subnet_id              = aws_subnet.public_subnet[0].id  # Use the first public subnet
  key_name = aws_key_pair.deployer.key_name
 
   associate_public_ip_address = true
 
  tags = {
    Name = "Bastion Host"
  }
}
 
# Variables for Bastion Host AMI and Instance Type
variable "ami_id" {
  description = "AMI ID for the bastion host"
  type        = string
  default     = "ami-047d7c33f6e7b4bc4"
}
 
variable "instance_type" {
  description = "Bastion host instance type"
  type        = string
  default     = "t2.micro"
}
 
# Output for Bastion Host IP
output "bastion_host_ip" {
  description = "The public IP address of the bastion host"
  value       = aws_instance.bastion_host.public_ip
}
