resource "aws_ecs_cluster" "ecs_workshop" {
    name = "ecs-workshop"

    tags = {
        CreatedBy   = "gbarrera"
        Environment = "dev"
        Project     = "flask-app"
    }
}

resource "aws_ecs_task_definition" "ecs_task_workshop" {
    family                   = "ecs-task-family-workshop"
    container_definitions    = file("/home/gustavo/Documentos/ProyectosExtras/2-TAJR-Semi/proyecto/terraform/modules/ecs/container-definitions/container-def.json")
    requires_compatibilities = ["FARGATE"]
    network_mode             = "awsvpc"
    memory                   = var.ecs_task_def_memory
    cpu                      = var.ecs_task_def_cpu
    execution_role_arn       = "${aws_iam_role.ecsTaskExecutionRole.arn}"
}

resource "aws_iam_role" "ecsTaskExecutionRole" {
    name               = "ecsTaskExecutionRole"
    assume_role_policy = "${data.aws_iam_policy_document.assume_role_policy.json}"
}

data "aws_iam_policy_document" "assume_role_policy" {
    statement {
        actions = ["sts:AssumeRole"]

        principals {
            type        = "Service"
            identifiers = ["ecs-tasks.amazonaws.com"]
        }
    }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
    role       = "${aws_iam_role.ecsTaskExecutionRole.name}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_service" "ecs_service_workshop" {
    name            = "ecs-service-workshop"
    cluster         = "${aws_ecs_cluster.ecs_workshop.id}"
    task_definition = "${aws_ecs_task_definition.ecs_task_workshop.arn}"
    launch_type     = "FARGATE"
    desired_count   = 2

    load_balancer {
        target_group_arn = "${var.lb_target_group_arn}"
        container_name   = "${aws_ecs_task_definition.ecs_task_workshop.family}"
        container_port   = 5000
    }

    network_configuration {
        subnets          = ["${var.subnet_a_id}", "${var.subnet_b_id}", "${var.subnet_c_id}"]
        assign_public_ip = true
        security_groups  = ["${aws_security_group.service_security_group.id}"]
    }
}

resource "aws_security_group" "service_security_group" {
    ingress {
        from_port = 0
        to_port   = 0
        protocol  = "-1"
        security_groups = ["${var.sg_lb_id}"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}