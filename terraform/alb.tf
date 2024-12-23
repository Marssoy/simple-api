resource "aws_lb_target_group" "alb-tg" {
    name = "alb-tg"
    port = 3000
    protocol = "HTTP"
    target_type = "ip"
    vpc_id = aws_vpc.kxc-vpc.id
    tags = {
        Name = "alb-tg"
    }
}

resource "aws_lb" "kxc-alb" {
    name = "lxc-alb"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.alb-sg.id]
    subnets = [
        aws_subnet.kxc-public-1a.id,
        aws_subnet.kxc-public-1b.id,
        aws_subnet.kxc-public-1c.id
        ]
    enable_deletion_protection = false
    tags = {
        Name = "kxc-alb"
    }
}

resource "aws_lb_listener" "alb-listener" {
    load_balancer_arn = aws_lb.kxc-alb.arn
    port = "3000"
    protocol = "HTTP"
    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.alb-tg.arn
    }
    tags = {
        Name = "alb-listener"
    }
}