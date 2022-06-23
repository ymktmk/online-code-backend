# ECSのロググループ
resource "aws_cloudwatch_log_group" "log_group_for_ecs" {
      name              = "/ecs/log/online-code"
      retention_in_days = 7
}
