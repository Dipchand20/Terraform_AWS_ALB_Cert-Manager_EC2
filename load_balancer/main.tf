variable "lb_name" {}
variable "lb_type" {}
variable "is_external" { default = false }
variable "sg_enable_ssh_https" {}
variable "subnet_id_us_east_1a" {}
variable "subnet_id_us_east_1b" {}
variable "tag_name" {}
variable "lb_target_group_arn" {}

variable "lb_listner_port" {}
variable "lb_listner_protocol" {}
variable "lb_listner_default_action" {}

variable "lb_https_listner_port" {}
variable "lb_https_listner_protocol" {}
variable "dipchand_acm_arn" {}

output "aws_lb_dns_name" {
  value = aws_lb.dipchand_yadav_lb.dns_name
}

output "aws_lb_zone_id" {
  value = aws_lb.dipchand_yadav_lb.zone_id
}


resource "aws_lb" "dipchand_yadav_lb" {
  name               = var.lb_name
  internal           = var.is_external
  load_balancer_type = var.lb_type
  security_groups    = [var.sg_enable_ssh_https]
  subnets            = [var.subnet_id_us_east_1a,var.subnet_id_us_east_1b]

  enable_deletion_protection = false

  tags = {
    Name = "example-lb"
  }
}



resource "aws_lb_listener" "dipchand_lb_listner" {
  load_balancer_arn = aws_lb.dipchand_yadav_lb.arn
  port              = var.lb_listner_port
  protocol          = var.lb_listner_protocol

  default_action {
    type             = var.lb_listner_default_action
    target_group_arn = var.lb_target_group_arn
  }
}

resource "aws_lb_listener" "dipchand_lb_https_listner" {
  load_balancer_arn = aws_lb.dipchand_yadav_lb.arn
  port              = var.lb_https_listner_port
  protocol          = var.lb_https_listner_protocol
  ssl_policy        = "ELBSecurityPolicy-FS-1-2-Res-2019-08"
  certificate_arn   = var.dipchand_acm_arn

  default_action {
    type             = var.lb_listner_default_action
    target_group_arn = var.lb_target_group_arn
  }
}
