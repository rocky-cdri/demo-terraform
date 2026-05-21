# ─────────────────────────────────────────────
# Application Load Balancer
# ─────────────────────────────────────────────
resource "aws_lb" "this" {
  name               = "${var.name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets            = var.subnet_ids

  enable_deletion_protection = var.certificate_arn != "" ? true : false

  tags = merge(var.tags, { Name = "${var.name}-alb" })
}

# ─────────────────────────────────────────────
# Target Group (기본 — Kubernetes Ingress에서 Override 가능)
# ─────────────────────────────────────────────
resource "aws_lb_target_group" "default" {
  name        = "${var.name}-default-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/health"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  tags = var.tags
}

# ─────────────────────────────────────────────
# HTTP Listener (HTTPS가 있으면 301 리다이렉트)
# ─────────────────────────────────────────────
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = var.certificate_arn != "" ? "redirect" : "forward"

    dynamic "redirect" {
      for_each = var.certificate_arn != "" ? [1] : []
      content {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }

    dynamic "forward" {
      for_each = var.certificate_arn == "" ? [1] : []
      content {
        target_group {
          arn = aws_lb_target_group.default.arn
        }
      }
    }
  }
}

# ─────────────────────────────────────────────
# HTTPS Listener (인증서가 있을 때만 생성)
# ─────────────────────────────────────────────
resource "aws_lb_listener" "https" {
  count = var.certificate_arn != "" ? 1 : 0

  load_balancer_arn = aws_lb.this.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.default.arn
  }
}
