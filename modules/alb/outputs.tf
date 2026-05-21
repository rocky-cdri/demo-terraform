output "alb_arn" {
  description = "ALB ARN"
  value       = aws_lb.this.arn
}

output "alb_dns_name" {
  description = "ALB DNS 이름"
  value       = aws_lb.this.dns_name
}

output "alb_zone_id" {
  description = "ALB Route53 Zone ID"
  value       = aws_lb.this.zone_id
}

output "http_listener_arn" {
  description = "HTTP Listener ARN"
  value       = aws_lb_listener.http.arn
}

output "https_listener_arn" {
  description = "HTTPS Listener ARN (없으면 null)"
  value       = length(aws_lb_listener.https) > 0 ? aws_lb_listener.https[0].arn : null
}

output "default_target_group_arn" {
  description = "기본 Target Group ARN"
  value       = aws_lb_target_group.default.arn
}
