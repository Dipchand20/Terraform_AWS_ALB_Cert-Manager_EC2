variable "ec2_name_subnet1" {
  
}

variable "ec2_name_subnet2" {
  
}

variable "ami_number_subnet_1" {

}
variable "security_group" {
  type        = list(string)
  description = "List of Security Group IDs"
  
}
variable "public_subnet_1_id" {
  
}
variable "public_subnet_2_id" {
  
}


output "my_instance_subnet_1_id" {
  value = aws_instance.my_instance_subnet_1.id
  
}

output "my_instance_subnet_2_id" {
  value = aws_instance.my_instance_subnet_2.id
  
}
resource "aws_instance" "my_instance_subnet_1" {
    
    ami = var.ami_number_subnet_1
    instance_type = "t2.micro"

    tags = {
      name=var.ec2_name_subnet1
    }
    associate_public_ip_address = true
    security_groups = var.security_group
    subnet_id = var.public_subnet_1_id
    key_name  = "dipchandyadav"
    user_data = <<-EOF
    #!/bin/bash
    # Update and install Nginx
    sudo apt update && sudo apt install -y nginx

    # Enable and start Nginx
    sudo systemctl enable nginx
    sudo systemctl start nginx
    EOF

}

resource "aws_instance" "my_instance_subnet_2" {
    ami = var.ami_number_subnet_1
    instance_type = "t2.micro"

    tags = {
      name=var.ec2_name_subnet2
    }
    security_groups = var.security_group

    associate_public_ip_address = true
    subnet_id = var.public_subnet_2_id
    key_name  = "dipchandyadav"
    
    user_data = <<-EOF
    #!/bin/bash
    # Update and install Nginx
    sudo apt update && sudo apt install -y nginx

    # Enable and start Nginx
    sudo systemctl enable nginx
    sudo systemctl start nginx
    EOF

}

