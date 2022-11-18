output "vpc-id" {
  value       = aws_vpc.VPC.id
}
output "subnet-id1" {
  value       = aws_subnet.PubSn1.id
}
output "subnet-id2" {
  value       = aws_subnet.PubSn2.id
}
output "subnet-id3" {
  value       = aws_subnet.PrvSn1.id
}
output "subnet-id4" {
  value       = aws_subnet.PrvSn2.id
}
