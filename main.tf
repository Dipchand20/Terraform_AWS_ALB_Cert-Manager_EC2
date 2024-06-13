

module "networking" {
    source = "./networking"
    cidr_block = var.cidr_block
    vpc_name = var.vpc_name
    aws_internet_gateway_name = var.aws_internet_gateway_name
    cidr_block_public_subnet_1 = var.cidr_block_public_subnet_1
    availability_zone_subnet_1 = var.availability_zone_subnet_1
    name_public_subnet_1 = var.name_public_subnet_1
    cidr_block_public_subnet_2 = var.cidr_block_public_subnet_2
    availability_zone_subnet_2 = var.availability_zone_subnet_2
    name_public_subnet_2 = var.name_public_subnet_2
    
 }

module "security_group" {
    source = "./security_group"
    name_security_group = var.name_security_group
    aws_vpc_id = module.networking.vpc_id
  
}
 
module "nginx_ec2" {
    source = "./nginx_ec2"
    ami_number_subnet_1 = var.ami_number_subnet_1
    security_group = [module.security_group.aws_security_group]
    public_subnet_1_id  = module.networking.subnet_id_us_east_1a
    public_subnet_2_id = module.networking.subnet_id_us_east_1b
    ec2_name_subnet1 = "dipchand-yadav-us-east-1a"
    ec2_name_subnet2 = "dipchand-yadav-us-east-1b"
}

module "load_balancer_target_group" {
    source = "./load_balancer_target_group"
    lb_target_group_name = "dipchand-la-taget-group"
    lb_target_group_port = "80"
    lb_target_group_protocol = "HTTP"
    vpc_id = module.networking.vpc_id
    my_instance_in_subnet_1_id = module.nginx_ec2.my_instance_subnet_1_id
    my_instance_in_subnet_2_id = module.nginx_ec2.my_instance_subnet_2_id
  
}

module "load_balancer" {
    source = "./load_balancer"
    lb_name = "DipchandYadavLoadBalancers"
    lb_type = "application"
    is_external = false
    sg_enable_ssh_https = module.security_group.aws_security_group
    subnet_id_us_east_1a =  module.networking.subnet_id_us_east_1a
    subnet_id_us_east_1b =  module.networking.subnet_id_us_east_1b
    tag_name = "load blancer"
    lb_target_group_arn = module.load_balancer_target_group.dipchand_lb_target_group_arn
    lb_listner_port           = 80
    lb_listner_protocol       = "HTTP"
    lb_listner_default_action = "forward"
    lb_https_listner_port = 443
    lb_https_listner_protocol = "HTTPS"
    dipchand_acm_arn = module.cerficate_manager.dipchand_yadav_acm_arn


  
}

module "hosted_zone" {
    source = "./hosted_zone"
    domain_name = "dip.dipchand.takemetoprod.com"
    aws_lb_dns_name = module.load_balancer.aws_lb_dns_name
    aws_lb_zone_id = module.load_balancer.aws_lb_zone_id

}

module "cerficate_manager" {
    source = "./cerficate_manager"
    domain_name = "dip.dipchand.takemetoprod.com"
    hosted_zone_id = module.hosted_zone.hosted_zone_id
}

