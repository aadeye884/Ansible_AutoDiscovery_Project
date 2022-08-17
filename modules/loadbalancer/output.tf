output "Jenkins-lb-dns" {
  value = aws_elb.lb.dns_name
}

output "target-group-arn" {
  value =  aws_lb_target_group.tg.arn
}

output "docker-lb-dns" {
  value = aws_lb.lb.dns_name
}

output "docker-lb-zone-id" {
  value = aws_lb.lb.zone_id
}