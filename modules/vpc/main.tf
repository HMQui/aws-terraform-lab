# modules/vpc/main.tf

# 1. Create VPC
resource "aws_vpc" "main" {
    cidr_block           = var.vpc_cidr
    enable_dns_support   = true
    enable_dns_hostnames = true
    tags = { Name = "Lab-VPC" }
}

# 2. Create Public Subnet
resource "aws_subnet" "public" {
    vpc_id                  = aws_vpc.main.id
    cidr_block              = var.public_subnet_cidr
    map_public_ip_on_launch = true # Cấp phát IP Public tự động
    tags = { Name = "Lab-Public-Subnet" }
}

# 3. Create Private Subnet
resource "aws_subnet" "private" {
    vpc_id     = aws_vpc.main.id
    cidr_block = var.private_subnet_cidr
    tags = { Name = "Lab-Private-Subnet" }
}

# 4. Create Internet Gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id
    tags = { Name = "Lab-IGW" }
}

# 5. Create Default Security Group for VPC
resource "aws_default_security_group" "default" {
    vpc_id = aws_vpc.main.id
}