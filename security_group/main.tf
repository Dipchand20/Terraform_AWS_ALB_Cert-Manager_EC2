

variable "aws_vpc_id" {
  
}

variable "name_security_group" {
  
}


output "aws_security_group" {
    value = aws_security_group.dipchand-yadav-SG.id
    description = "Allow HTTP, HTTPS, and SSH"
  
}



resource "aws_security_group" "dipchand-yadav-SG" {
    vpc_id = var.aws_vpc_id
    name = var.name_security_group
    description = "Allow HTTP, HTTPS, and SSH"



  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow HTTP, HTTPS, and SSH"
  }
  
}