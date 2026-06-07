# modules/vpc/routing.tf

# 1. Khởi tạo Elastic IP cho NAT Gateway
resource "aws_eip" "nat" {
    domain = "vpc"
    tags = { Name = "Lab-NAT-EIP" }
}

# 2. Khởi tạo NAT Gateway
resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.nat.id
    subnet_id     = aws_subnet.public.id
    tags = { Name = "Lab-NAT-GW" }

    # Đảm bảo IGW được tạo trước khi tạo NAT Gateway
    depends_on = [aws_internet_gateway.igw]
}

# 3. Tạo Public Route Table
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = { Name = "Lab-Public-RT" }
}

# 4. Gắn Public Route Table vào Public Subnet
resource "aws_route_table_association" "public" {
    subnet_id      = aws_subnet.public.id
    route_table_id = aws_route_table.public.id
}

# 5. Tạo Private Route Table
resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block     = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat.id
    }

    tags = { Name = "Lab-Private-RT" }
}

# 6. Gắn Private Route Table vào Private Subnet
resource "aws_route_table_association" "private" {
    subnet_id      = aws_subnet.private.id
    route_table_id = aws_route_table.private.id
}