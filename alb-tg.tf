data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_subnets" "subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }
}


resource "aws_lb_target_group" "bilal-target" {
  name        = "proje-202-target-group"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  health_check {
    enabled             = true
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 10
  }
  vpc_id = data.aws_vpc.default_vpc.id

}



resource "aws_lb" "bilal-alb" {
  name                       = "proje-202-alb"
  load_balancer_type         = "application"
  security_groups = [aws_security_group.load-balancer-sec.id]
  enable_deletion_protection = false
  subnets = data.aws_subnets.subnets.ids

}

resource "aws_lb_listener" "bilal-listener" {
  load_balancer_arn = aws_lb.bilal-alb.arn
  port              = "80"
  protocol          = "HTTP"


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.bilal-target.arn
  }
}

