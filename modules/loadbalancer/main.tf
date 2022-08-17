# Create a jenkins elastic load balancer
resource "aws_elb" "lb" {
  name               = var.elb_name
  subnets = var.subnet_id  
  security_groups = var.elb-sg1

  listener {
    instance_port     = 8080
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:8080"
    interval            = 30
  }

  instances                   = var.elb-instance    #[aws_instance.jenkins.id]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = var.elb_tag
  }
}

#Creating Application Load Balancer for Docker lb
resource "aws_lb" "lb" {
  name               = var.lb
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.lb-sg1   
  subnets            = var.subnet_id2    
  enable_deletion_protection = false
  tags = {
    Name = var.lb_tag
  }
}

# Creating the target group 
resource "aws_lb_target_group" "tg" {
  name     = var.tg-name
  port     = var.custom_http
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "instance"
  health_check {
    healthy_threshold = var.healthy_threshold_tg
    unhealthy_threshold = var.unhealthy_threshold_tg
    timeout = var.timeout_tg
    interval = var.interval_tg
    
  }
}
## Create target group attachement
resource "aws_lb_target_group_attachment" "attachmenet_tg" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = var.lb-instance
    port             = 80
}

### Create listener
resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}