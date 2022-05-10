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
      schedule_expression = "cron(52 14 * * ? *)"
}

resource "aws_cloudwatch_event_target" "start_target" {
      arn       = "arn:aws:ssm:ap-northeast-1::automation-definition/AWS-StartEC2Instance"
      rule      = aws_cloudwatch_event_rule.online_code_ec2_start.name
      role_arn  = aws_iam_role.online_code_ec2_start_role.arn
      input     =  <<EOF
{
      "InstanceId": ["i-06d56bdfb020ed388"]
}
EOF
}

# EC2 Stop ちゃんと動く
resource "aws_iam_role" "online_code_ec2_stop_role" {
      name = "online_code_ec2_stop_role"
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

resource "aws_iam_role_policy" "online_code_ec2_stop_role_policy" {
      name = "online_code_ec2_stop_role_policy"
      role = aws_iam_role.online_code_ec2_stop_role.id
      policy = <<EOF
{
      "Version": "2012-10-17",
      "Statement": [
            {
                  "Sid": "CloudWatchEventsBuiltInTargetExecutionAccess",
                  "Effect": "Allow",
                  "Action": [
                        "ec2:RebootInstances",
                        "ec2:StopInstances",
                        "ec2:TerminateInstances"
                  ],
                  "Resource": [
                        "arn:aws:ec2:ap-northeast-1:009554248005:instance/i-06d56bdfb020ed388"
                  ]
            }
      ]
}
EOF
}

resource "aws_cloudwatch_event_rule" "online_code_ec2_stop" {
      name                = "online-code-ec2-stop"
      schedule_expression = "cron(45 13 * * ? *)"
}

resource "aws_cloudwatch_event_target" "stop_target" {
      arn       = "arn:aws:events:ap-northeast-1:009554248005:target/stop-instance"
      rule      = aws_cloudwatch_event_rule.online_code_ec2_stop.name
      role_arn  = aws_iam_role.cloudwatch_role.arn
      input     =  jsonencode("i-06d56bdfb020ed388")
}