provider "aws" 
{
region = "us-east-1"
}



#Varibles
variable "vpc_cidr"
 {
  default = "10.0.0.0/16"
}
variable "public_subnet_cidr" 
{
  default = "10.0.1.0/24"
}
variable "private_subnet_cidr" 
{
  default = "10.0.2.0/24"
}
variable "availability_zone" 
{
  default = "us-east-1a"
}
variable "instance_type" 
{
  default = "t2.micro"
}
variable "ami_id" 
{
  default = "ami-0c94855ba95c71c99"
}

# Create VPC
resource "aws_vpc" "SubhrajitVPC" 
{
  cidr_block = var.vpc_cidr
  dns_support = true
  dns_hostnames = true
  tags = { Name = "SubhrajitVPC-vpc"}
}

# Internet Gateway
resource "aws_internet_gateway" "igw" 
{
  vpc_id = aws_vpc.SubhrajitVPC.id
  tags = {Name = "SubhrajitVPC-igw"}
}




# Public Subnet
resource "aws_subnet" "public"
 {
  vpc_id = aws_vpc.SubhrajitVPC.id
  cidr_block = var.public_subnet_cidr
  availability_zone = var.availability_zone
  map_public_ip_on_launch = true
  tags = {Name = "public-subnet"}
}

# Private Subnet
resource "aws_subnet" "private" 
{
  vpc_id = aws_vpc.SubhrajitVPC.id
  cidr_block = var.private_subnet_cidr
  availability_zone = var.availability_zone
  tags = {Name = "private-subnet"}
}








# Public Route Table
resource "aws_route_table" "public" 
{
  vpc_id = aws_vpc.SubhrajitVPC.id
route 
{
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
tags = {Name = "public-rt"}
}

# Security Group for HTTP/HTTPS
resource "aws_security_group" "web_sg" 
{
  name = "web-sg"
  description = "Allow HTTP and HTTPS"
  vpc_id      = aws_vpc.SubhrajitVPC.id

  ingress 
{
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP"
  }

  ingress 
{
    from_prot   = 443
    to_port     = 443
    prtocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS"
  }

  egress 
{
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }
tags = {Name = "web-sg"}
}





# EC2 Instance in Public Subnet
resource "aws_instance" "web" 
{
  ami = var. ami-0c94855ba95c71c99
  instance_type = var.instance_type
  subnet_id = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install nginx1 -y
              systemctl start nginx
              systemctl enable nginx
              EOF
tags = {Name = "web-server"}
}

# Output the public IP
output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.web.public_ip
}
