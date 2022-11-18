# Create an elastic/classic load balancer for Jenkins
resource "aws_elb" "lb_jenkins" {
  name               = var.elb_name
  subnets =   var.subnet_id  
  security_groups = var.elb_sg1

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

