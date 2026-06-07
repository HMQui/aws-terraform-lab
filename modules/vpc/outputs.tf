# modules/vpc/outputs.tf

output "vpc_id" {
    description = "ID VPC"
    value       = aws_vpc.main.id
}

output "public_subnet_id" {
    description = "ID Public Subnet"
    value       = aws_subnet.public.id
}

output "private_subnet_id" {
    description = "ID Private Subnet"
    value       = aws_subnet.private.id
}

output "igw_id" {
    description = "ID Internet Gateway"
    value       = aws_internet_gateway.igw.id
}