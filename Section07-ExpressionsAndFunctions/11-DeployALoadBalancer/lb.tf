resource "aws_lb" "schoolapp" {
  name               = var.project_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.schoolapp-alb.id]
  subnets            = [for subnet in aws_subnet.schoolapp : subnet.id]

  enable_deletion_protection = false

  tags = local.mytags
}

resource "aws_lb_listener" "schoolapp" {
  load_balancer_arn = aws_lb.schoolapp.arn
  port              = var.http_port
  protocol          = "HTTP"

  default_action {
    fixed_response {
      content_type = "text/plain"
      message_body = "404 - Page Not Found"
      status_code  = 404
    }
    type = "fixed-response"
  }

  tags = local.mytags
}

resource "aws_security_group" "schoolapp-alb" {
  name   = "${var.project_name}-lb"
  vpc_id = aws_vpc.schoolapp.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all traffic from the Internet inbound on port 80"
    from_port   = var.http_port
    protocol    = "tcp"
    to_port     = var.http_port
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all traffic outbound"
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  tags = local.mytags
}

resource "aws_lb_target_group" "schoolapp" {
  name     = var.project_name
  port     = var.http_port
  protocol = "HTTP"
  vpc_id   = aws_vpc.schoolapp.id
  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = local.mytags
}

resource "aws_lb_listener_rule" "schoolapp" {
  listener_arn = aws_lb_listener.schoolapp.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.schoolapp.arn
  }

  tags = local.mytags
}
