resource "aws_launch_configuration" "ecs_launch_config" {
      name                 = "online-code-cluster"
      image_id             = data.aws_ami.ami.id
      iam_instance_profile = aws_iam_instance_profile.ecs_instance_role.name
      security_groups      = [aws_security_group.security_group.id]
      # 起動時のシェルスクリプト
      user_data            = <<EOF
#!/bin/bash
echo ECS_CLUSTER=online-code-cluster >> /etc/ecs/ecs.config;
INSTANCE_ID=`curl http://169.254.169.254/latest/meta-data/instance-id`
aws ec2 associate-address --allocation-id ${aws_eip.eip.allocation_id} --instance $INSTANCE_ID
EOF
      instance_type        = "t2.micro"
      key_name               = aws_key_pair.key_pair.id
      lifecycle {
            create_before_destroy = true
      }
}

resource "aws_autoscaling_group" "ecs_autoscaling_group" {
      name                      = "ecs_autoscaling_group"
      vpc_zone_identifier       = [aws_subnet.public_subnet.id]
      launch_configuration      = aws_launch_configuration.ecs_launch_config.name
      min_size                  = 0
      max_size                  = 1
      desired_capacity          = 1
      health_check_grace_period = 0
      protect_from_scale_in = true
      lifecycle {
            create_before_destroy = true
      }
      health_check_type         = "EC2"
}
