
variable "vpc_name" {
  
}
variable "cidr_block" {
  
}

variable "aws_internet_gateway_name" {
  
}

variable "cidr_block_public_subnet_1" {
  
}
variable "availability_zone_subnet_1" {
  
}
variable "name_public_subnet_1" {

}

variable "cidr_block_public_subnet_2" {
  
}
variable "availability_zone_subnet_2" {
  
}
variable "name_public_subnet_2" {
  
}


output "vpc_id" {
  value       = aws_vpc.main.id
  description = "The ID of the VPC created"
}

output "subnet_id_us_east_1a" {
  value = aws_subnet.public_subnet_1.id
}

output "subnet_id_us_east_1b" {
  value = aws_subnet.public_subnet_2.id
}

resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block
  

  tags = {
    Name = var.vpc_name
  }
}



resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.aws_internet_gateway_name
  }
}


resource "aws_subnet" "public_subnet_1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidr_block_public_subnet_1
  availability_zone = var.availability_zone_subnet_1

  tags = {
    Name = var.name_public_subnet_1
  }
}


resource "aws_subnet" "public_subnet_2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidr_block_public_subnet_2
  availability_zone = var.availability_zone_subnet_2

  tags = {
    Name = var.name_public_subnet_2
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

   tags = {
    Name = "dipchand-project-RT"
  }

}

resource "aws_route_table_association" "public_subnet_1" {
  subnet_id = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.main.id
  
}

resource "aws_route_table_association" "public_subnet_2" {
  subnet_id = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.main.id
  
}



