# VPC ID
output "vpc_id" {
  value = aws_vpc.this.id
  description = "The ID of the VPC"
}

# Public Subnet IDs
output "public_subnet_ids" {
  value = aws_subnet.public[*].id
  description = "List of public subnet IDs"
}

# Private Subnet IDs
output "private_subnet_ids" {
  value = aws_subnet.private[*].id
  description = "List of private subnet IDs"
}

# Internet Gateway ID
output "internet_gateway_id" {
  value = aws_internet_gateway.this.id
  description = "ID of the Internet Gateway"
}

# NAT Gateway ID
output "nat_gateway_id" {
  value = aws_nat_gateway.this.id
  description = "ID of the NAT Gateway"
}

# Public Route Table ID
output "public_route_table_id" {
  value = aws_route_table.public.id
  description = "ID of the public route table"
}

# Private Route Table ID
output "private_route_table_id" {
  value = aws_route_table.private.id
  description = "ID of the private route table"
}
