resource "aws_alb" "alb" {
  name                       = "${var.r_prefix}-alb"
  security_groups            = [aws_security_group.sg_alb.id]

  subnets                    = [
    "${aws_subnet.public_subnet_1a.id}",
    "${aws_subnet.public_subnet_1c.id}"
  ]

  internal                   = false
  enable_deletion_protection = false

  access_logs {
    bucket  = "${aws_s3_bucket.alb_logs.bucket}"
  }
}

## Target Group
resource "aws_alb_target_group" "alb_target_blue" {
  name        = "${var.r_prefix}-blue-nlb-tg"
  port        = 80
  depends_on  = [aws_alb.alb]
  protocol    = "HTTP"
  vpc_id      = "${aws_vpc.vpc.id}"
  target_type = "ip"
  deregistration_delay = 15

  health_check {
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
    matcher             = 200
  }
}

resource "aws_alb_listener" "alb_listener" {
  port              = "80"
  protocol          = "HTTP"

  load_balancer_arn = "${aws_alb.alb.arn}"

  # blueとgreenのtgを動的に入れ替えるのでignoreする
  lifecycle {
    ignore_changes = [default_action]
  }

  default_action {
    target_group_arn = "${aws_alb_target_group.alb_target_blue.arn}"
    type             = "forward"
  }
}
