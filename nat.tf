# Elastic IP resource definition
resource "aws_eip" "eip_nat" {
  count     = 2  # Assuming you want two Elastic IPs
  domain    = "vpc"
}
 
# NAT Gateway resource definition
resource "aws_nat_gateway" "my_nat_gateway" {
  count        = 2
  allocation_id = aws_eip.eip_nat[count.index].id
  subnet_id    = aws_subnet.public_subnet[count.index].id  # Use count.index to get each public subnet
 
  tags = {
    Name = "my_nat_gateway_${count.index + 1}"
  }
}
 