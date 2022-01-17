# ====================
# Cluster
# ====================
resource "aws_ecs_cluster" "online-code" {
    id                 = "arn:aws:ecs:ap-northeast-1:009554248005:cluster/online-code"
    name               = "online-code"
}

# ====================
# task_definition
# ====================
resource "aws_ecs_task_definition" "online-code" {
    container_definitions    = jsonencode(
        [
            {
                command          = [
                    "/main",
                ]
                cpu              = 0
                environment      = []
                essential        = true
                image            = "009554248005.dkr.ecr.ap-northeast-1.amazonaws.com/onlinecode_app:24bfa298e48f1da503df43012a8ef67a4ce31145"
                logConfiguration = {
                    logDriver = "awslogs"
                    options   = {
                        awslogs-group         = "online-code-ecs"
                        awslogs-region        = "ap-northeast-1"
                        awslogs-stream-prefix = "app"
                    }
                }
                mountPoints      = [
                    {
                        containerPath = "/go/src/work"
                        readOnly      = false
                        sourceVolume  = "mount"
                    },
                    {
                        containerPath = "/var/run/docker.sock"
                        sourceVolume  = "socket"
                    },
                ]
                name             = "code"
                portMappings     = [
                    {
                        containerPort = 10000
                        hostPort      = 10000
                        protocol      = "tcp"
                    },
                ]
                volumesFrom      = []
            },
        ]
    )
    cpu                      = "256"
    family                   = "online-code"
    id                       = "online-code"
    memory                   = "512"
    requires_compatibilities = [
        "EC2",
    ]
    revision                 = 33
    volume {
        host_path = "/"
        name      = "mount"
    }
    volume {
        host_path = "/var/run/docker.sock"
        name      = "socket"
    }
}

# ====================
# Service
# ====================
resource "aws_ecs_service" "online-code" {
    deployment_maximum_percent         = 200
    deployment_minimum_healthy_percent = 100
    desired_count                      = 1
    enable_ecs_managed_tags            = true
    enable_execute_command             = false
    health_check_grace_period_seconds  = 0
    id                                 = "arn:aws:ecs:ap-northeast-1:009554248005:service/online-code/online-code"
    launch_type                        = "EC2"
    name                               = "online-code"
    propagate_tags                     = "NONE"
    scheduling_strategy                = "REPLICA"
    task_definition                    = "online-code:33"

    deployment_circuit_breaker {
        enable   = false
        rollback = false
    }

    deployment_controller {
        type = "ECS"
    }

    ordered_placement_strategy {
        field = "attribute:ecs.availability-zone"
        type  = "spread"
    }
    ordered_placement_strategy {
        field = "instanceId"
        type  = "spread"
    }
}
