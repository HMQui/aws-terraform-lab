# modules/vpc/variables.tf

variable "vpc_cidr" {
    description = "CIDR block cho VPC"
    type        = string
    default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
    description = "CIDR block cho Public Subnet"
    type        = string
    default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
    description = "CIDR block cho Private Subnet"
    type        = string
    default     = "10.0.2.0/24"
}