# ECSのロググループ
resource "aws_cloudwatch_log_group" "log_group_for_ecs" {
      name              = "/aws/ecs"
}