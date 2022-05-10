# https://www.it-ouji.com/2021/08/30/aws-eventbridge%E3%81%A7ssm-automation%E3%82%92%E4%BD%BF%E7%94%A8%E3%81%97%E3%81%A6ec2%E3%81%AE%E9%96%8B%E5%A7%8B%E3%81%A8%E5%81%9C%E6%AD%A2%E3%82%92%E3%82%B9%E3%82%B1%E3%82%B8%E3%83%A5%E3%83%BC/
# terraform apply -target={aws_cloudwatch_event_rule.online_code_ec2_start,aws_cloudwatch_event_target.start_target,aws_iam_role.cloudwatch_role,aws_iam_role_policy_attachment.ssm_automation_policy}
resource "aws_iam_role" "online_code_ec2_start_role" {
      name = "online_code_ec2_start_role"
      assume_role_policy = <<EOF
{
      "Version": "2012-10-17",
      "Statement": [
            {
                  "Effect": "Allow",
                  "Principal": {
                        "Service": "events.amazonaws.com"
                  },
                  "Action": "sts:AssumeRole"
            }
      ]
}
EOF
}

# 作成済みのポリシー
resource "aws_iam_role_policy_attachment" "ssm_automation_policy" {
	role = aws_iam_role.online_code_ec2_start_role.name
	policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonSSMAutomationRole"
}

# EC2 Start
resource "aws_cloudwatch_event_rule" "online_code_ec2_start" {
      name                = "online-code-ec2-start"
      schedule_expression = "cron(22 14 * * ? *)"
}

resource "aws_cloudwatch_event_target" "start_target" {
      arn       = "arn:aws:events:ap-northeast-1:009554248005:target/reboot-instance"
      rule      = aws_cloudwatch_event_rule.online_code_ec2_start.name
      role_arn  = aws_iam_role.cloudwatch_role.arn
      input     =  jsonencode("i-06d56bdfb020ed388")
}



# EC2 Stop ちゃんと動く
# resource "aws_iam_role" "online_code_ec2_stop_role" {
#       name = "online_code_ec2_stop_role"
#       assume_role_policy = <<EOF
# {
#       "Version": "2012-10-17",
#       "Statement": [
#             {
#                   "Effect": "Allow",
#                   "Principal": {
#                         "Service": "events.amazonaws.com"
#                   },
#                   "Action": "sts:AssumeRole"
#             }
#       ]
# }
# EOF
# }

# resource "aws_iam_role_policy" "online_code_ec2_stop_role_policy" {
#       name = "online_code_ec2_stop_role_policy"
#       role = aws_iam_role.online_code_ec2_stop_role.id
#       policy = <<EOF
# {
#       "Version": "2012-10-17",
#       "Statement": [
#             {
#                   "Sid": "CloudWatchEventsBuiltInTargetExecutionAccess",
#                   "Effect": "Allow",
#                   "Action": [
#                         "ec2:RebootInstances",
#                         "ec2:StopInstances",
#                         "ec2:TerminateInstances"
#                   ],
#                   "Resource": [
#                         "arn:aws:ec2:ap-northeast-1:009554248005:instance/i-06d56bdfb020ed388"
#                   ]
#             }
#       ]
# }
# EOF
# }

# resource "aws_cloudwatch_event_rule" "online_code_ec2_stop" {
#       name                = "online-code-ec2-stop"
#       schedule_expression = "cron(45 13 * * ? *)"
# }

# resource "aws_cloudwatch_event_target" "stop_target" {
#       arn       = "arn:aws:events:ap-northeast-1:009554248005:target/stop-instance"
#       rule      = aws_cloudwatch_event_rule.online_code_ec2_stop.name
#       role_arn  = aws_iam_role.cloudwatch_role.arn
#       input     =  jsonencode("i-06d56bdfb020ed388")
# }