output "wordpress_web_sg" {
  value = aws_security_group.wordpress_web.id
}

output "elb_sg" {
  value = aws_security_group.elb.id
}
