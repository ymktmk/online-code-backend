# クラスター
resource "aws_ecs_cluster" "cluster" {
    name = "cluster"
    # 既存のリソースが有った場合に、一旦削除してから作り直すようになります
    lifecycle {
        create_before_destroy = true
    }
}

# タスク定義
resource "aws_ecs_task_definition" "task_definition" {
    container_definitions    = jsonencode(
        [
            {
                command          = ["/main",]
                cpu              = 0
                essential        = true
                # ECRのイメージ
                image            = "009554248005.dkr.ecr.ap-northeast-1.amazonaws.com/onlinecode_app:9d12662e7c4ba57a5bfda27df1df8db9ad294cd3"
                # CloudWatchのログ
                logConfiguration = {
                    logDriver = "awslogs"
                    options   = {
                        awslogs-region        = "ap-northeast-1"
                        awslogs-stream-prefix = aws_cloudwatch_log_group.log_group_for_ecs.name
                        awslogs-group         = "online-code-ecs"
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
            },
        ]
    )
    cpu                      = "256"
    family                   = "online-code"
    memory                   = "512"
    requires_compatibilities = ["EC2"]
    volume {
        host_path = "/"
        name      = "mount"
    }
    volume {
        host_path = "/var/run/docker.sock"
        name      = "socket"
    }
}

# サービス
resource "aws_ecs_service" "service" {
    name                               = "service"
    cluster                            = aws_ecs_cluster.cluster.id
    deployment_maximum_percent         = 100
    deployment_minimum_healthy_percent = 0
    desired_count                      = 1
    force_new_deployment    = true
    scheduling_strategy                = "REPLICA"
    task_definition                    = aws_ecs_task_definition.task_definition.arn
}