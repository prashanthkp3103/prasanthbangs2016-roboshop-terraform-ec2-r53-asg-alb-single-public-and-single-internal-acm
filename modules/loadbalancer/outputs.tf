#sending lb dns name to utilize in asg module r53
output "dns_name" {
  value = aws_lb.main.dns_name
}

output "listener_arn" {
  value = aws_lb_listener.main.arn
}