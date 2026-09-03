resource "aws_alb" "application_load_balancer" {
    name               = "ecs-workshop-lb"
    load_balancer_type = "application"
    subnets = [
        "${var.subnet_a_id}",
        "${var.subnet_b_id}",
        "${var.subnet_c_id}"
    ]
    
    security_groups = ["${aws_security_group.load_balancer_security_group.id}"]
}

resource "aws_security_group" "load_balancer_security_group" {
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_lb_target_group" "target_group" {
    name        = "ecs-workshop-target-group"
    port        = 5000
    protocol    = "HTTP"
    target_type = "ip"
    vpc_id      = "${var.default_vpc_id}"
    health_check {
        matcher = "200,301,302"
        path = "/"
    }
}

resource "aws_lb_listener" "listener" {
    load_balancer_arn = "${aws_alb.application_load_balancer.arn}"
    port              = "80"
    protocol          = "HTTP"
    default_action {
        type             = "forward"
        target_group_arn = "${aws_lb_target_group.target_group.arn}"
    }
}