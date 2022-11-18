output "Jenkins-lb-dns" {
  value = aws_elb.lb_jenkins.dns_name
}