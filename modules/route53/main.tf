# Provision aws route_53 
resource "aws_route53_zone" "UST1-zone" {
  name = var.domain_name
  force_destroy = true
}

# Create Route 53 A Record and Alias
resource "aws_route53_record" "UST1-record" {
  zone_id = aws_route53_zone.UST1-zone.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.lb_dns_name
    zone_id                = var.lb_zone_id
    evaluate_target_health = true
  }
}
                           
                           