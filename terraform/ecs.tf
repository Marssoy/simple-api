resource "aws_ecs_cluster" "kxc-cluster" {
    name = "kxc-cluster"
}

resource "aws_ecs_task_definition" "kxc-task" {
    family = "kxc-task"
    requires_compatibilities = ["FARGATE"]
    network_mode = "awsvpc"
    cpu = 1024
    memory = 3072
    execution_role_arn = aws_iam_role.ecs-task-execution-role.arn
    container_definitions = jsonencode([
        {
            name = "kxc-simple-api"
            image = "851725492449.dkr.ecr.us-east-1.amazonaws.com/kxc-simple-api"
            cpu = 1024
            memory = 3072
            essential = true
            portMappings = [
                {
                    containerPort = 3000
                    protocol = "tcp"
                }
            ]
        }
    ])
}

resource "aws_ecs_service" "kxc-service" {
    name = "kxc-service"
    cluster = aws_ecs_cluster.kxc-cluster.id
    task_definition = aws_ecs_task_definition.kxc-task.id
    desired_count = 1
    launch_type = "FARGATE"
    network_configuration {
      subnets = [aws_subnet.kxc-public-1a.id, aws_subnet.kxc-public-1b.id, aws_subnet.kxc-public-1c.id]
      security_groups = [aws_security_group.kxc-fargate-sg.id]
      assign_public_ip = true
    }
    load_balancer {
      target_group_arn = aws_lb_target_group.alb-tg.arn
      container_name = "kxc-simple-api"
      container_port = 3000
    }
    depends_on = [aws_lb_listener.alb-listener]
}