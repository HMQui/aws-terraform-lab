# modules/ec2/variables.tf

variable "vpc_id" {
    description = "ID VPC"
    type        = string
}

variable "public_subnet_id" {
    description = "ID Public Subnet"
    type        = string
}

variable "private_subnet_id" {
    description = "ID Private Subnet"
    type        = string
}

variable "allowed_ssh_ip" {
    description = "IP allows Public EC2"
    type        = string
    default     = "0.0.0.0/0"
}