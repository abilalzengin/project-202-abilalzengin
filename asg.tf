
resource "aws_autoscaling_group" "bilal-asg" {
  name                      = "project-202-asg"
  max_size                  = 3
  min_size                  = 1
  health_check_grace_period = 200
  health_check_type         = "ELB"
  desired_capacity          = 2
  force_delete              = true
  launch_template {
    id      = aws_launch_template.bilal-lt.id
    version = "1"
  }
  vpc_zone_identifier = aws_lb.bilal-alb.subnets

  tag {
    key                 = "name"
    value               = "bilal-1"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "scale_down" {
  autoscaling_group_name = aws_autoscaling_group.bilal-asg.name
  name                   = "bilal-scale-down"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "120"
}

resource "aws_cloudwatch_metric_alarm" "bilal-scale-down" {
  alarm_name          = "bilal-scale_down"
  alarm_description   = "scale-down-for-CPU"
  alarm_actions       = [aws_autoscaling_policy.scale_down.arn]
  comparison_operator = "LessThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = "20"
  statistic           = "Average"
  period              = "60"
  evaluation_periods  = "3"
  dimensions = {
    autoscaling_group_name = aws_autoscaling_group.bilal-asg.name
  }
  
}

resource "aws_autoscaling_policy" "scale_up" {
  autoscaling_group_name = aws_autoscaling_group.bilal-asg.name
  name                   = "bilal-scale-up"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "+1"
  cooldown               = "120"
}

resource "aws_cloudwatch_metric_alarm" "bilal-scale-up" {
  alarm_name          = "bilal-scale_up"
  alarm_description   = "scale-up-for-CPU"
  alarm_actions       = [aws_autoscaling_policy.scale_up.arn]
  comparison_operator = "GreaterThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = "55"
  statistic           = "Average"
  period              = "60"
  evaluation_periods  = "3"
  dimensions = {
    autoscaling_group_name = aws_autoscaling_group.bilal-asg.name
  }
}

resource "aws_autoscaling_attachment" "bilal-attachment" {
  autoscaling_group_name = aws_autoscaling_group.bilal-asg.id
  lb_target_group_arn    = aws_lb_target_group.bilal-target.arn

}

