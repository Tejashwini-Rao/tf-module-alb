resource "aws_lb" "public" {
  name               = "${var.ENV}-public"
  internal           = false
  load_balancer_type = "application"
  security_groups    = aws_security_group.public.name
  subnets            = var.public_subnets
}

resource "aws_security_group" "public" {
  name        = "${var.ENV}-public"
  description = "${var.ENV}-public"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [0.0.0.0/0]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [0.0.0.0]
  }
}

resource "aws_lb_listener" "front_end" {
    load_balancer_arn = aws_lb.public.arn
    port              = "443"
    protocol          = "HTTPS"
    ssl_policy        = "ELBSecurityPolicy-2016-08"
    certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

    default_action {
      type             = "forward"
      target_group_arn = aws_lb_target_group.alb.arn
    }
  }

resource "aws_lb_target_group" "alb" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

