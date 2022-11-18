output "Load_Balancer_dns" {
  value       = aws_lb.UST1-alb.dns_name
}
output "Load_Balancer_zone_id" {
  value       = aws_lb.UST1-alb.zone_id
}