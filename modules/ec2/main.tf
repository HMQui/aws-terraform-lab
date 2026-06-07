# modules/ec2/main.tf

# 1. Tạo SSH Key Pair tự động
resource "tls_private_key" "lab_key" {
    algorithm = "RSA"
    rsa_bits  = 2048
}

resource "aws_key_pair" "lab_key_pair" {
    key_name   = "lab-ec2-key"
    public_key = tls_private_key.lab_key.public_key_openssh
}

# 2. Public Security Group
resource "aws_security_group" "public_sg" {
    name        = "Public-EC2-SG"
    description = "Allow SSH from specific IP"
    vpc_id      = var.vpc_id

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [var.allowed_ssh_ip]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# 3. Private Security Group
resource "aws_security_group" "private_sg" {
    name        = "Private-EC2-SG"
    description = "Allow SSH from Public EC2 only"
    vpc_id      = var.vpc_id

    ingress {
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        security_groups = [aws_security_group.public_sg.id] # Chỉ nhận từ Public SG
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# 4. Lấy AMI Amazon Linux 2023 mới nhất
data "aws_ami" "amazon_linux" {
    most_recent = true
    owners      = ["amazon"]

    filter {
        name   = "name"
        values = ["al2023-ami-2023.*-x86_64"]
    }
}

# 5. Khởi tạo Public EC2 Instance
resource "aws_instance" "public_instance" {
    ami                         = data.aws_ami.amazon_linux.id
    instance_type               = "t2.micro"
    subnet_id                   = var.public_subnet_id
    vpc_security_group_ids      = [aws_security_group.public_sg.id]
    key_name                    = aws_key_pair.lab_key_pair.key_name
    associate_public_ip_address = true

    tags = { Name = "Lab-Public-EC2" }
}

# 6. Khởi tạo Private EC2 Instance
resource "aws_instance" "private_instance" {
    ami                    = data.aws_ami.amazon_linux.id
    instance_type          = "t2.micro"
    subnet_id              = var.private_subnet_id
    vpc_security_group_ids = [aws_security_group.private_sg.id]
    key_name               = aws_key_pair.lab_key_pair.key_name

    tags = { Name = "Lab-Private-EC2" }
}

resource "local_file" "private_key" {
    content         = tls_private_key.lab_key.private_key_pem
    filename        = "${path.root}/lab-ec2-key.pem"
    file_permission = "0400"
}