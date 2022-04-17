# # Fetching Just One pub ip in the list
# output "public_ip" {
#   description = "public ip"
#   value       = aws_instance.web[0].public_ip 
#   sensitive   = false
# }

# # fetching all of the public_ip in the list
# output "public_ip2" {
#   description = "public ip2"
#   value       = [aws_instance.web[*].public_ip]
#   sensitive   = false
# }

# # what if we want just two of the pub ip in the list
# output "public_ip3" {
#   description = "public ip3"
#   value       = slice(aws_instance.web[*].public_ip,0, )
#   sensitive   = false
# }

# # For loop with output 

# output "ec2_arn" {
#   description = "ec2 arn's"
#   value       = [for arn in aws_instance.web: arn.arn]
#   sensitive   = false
# }

#output "public_ip" {
#  value = format("http://%s", aws_instance.web[0].public_ip)
#}

output "pub_subnet" {
  value = aws_subnet.public_subnet[*].id
}

# Deprecated
output "private_subnet" {
  value = aws_subnet.priv_sub.*.id
}

# for loop
output "database_subnet" {
  value = [for ids in aws_subnet.database_sub : ids.id]
}
/*
output "lb_id" {
  description = "The ID and ARN of the load balancer we created."
  value       = aws_lb.kojitechs-lb.id
}

output "lb_arn" {
  description = "The ID and ARN of the load balancer we created."
  value       = aws_lb.kojitechs-lb.arn
}
# aws_lb" "kojitechs-lb
output "lb_dns_name" {
  description = "The DNS name of the load balancer."
  value       = aws_lb.kojitechs-lb.dns_name
}

output "lb_arn_suffix" {
  description = "ARN suffix of our load balancer - can be used with CloudWatch."
  value       = aws_lb.kojitechs-lb.arn_suffix
}

output "lb_zone_id" {
  description = "The zone_id of the load balancer to assist with creating DNS records."
  value       = aws_lb.kojitechs-lb.zone_id
}*/

output "dns_name" {

  value = format("https://%s", var.register_dns)
}
