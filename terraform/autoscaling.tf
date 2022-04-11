# AutoScaling EC2起動設定
resource "aws_launch_configuration" "ecs_launch_config" {
      name                 = "cluster"
      image_id             = data.aws_ami.ami.id
      iam_instance_profile = aws_iam_instance_profile.ecs_instance_role.name
      security_groups      = [aws_security_group.security_group.id]
      user_data            = <<EOF
#!/bin/bash
echo ECS_CLUSTER=cluster >> /etc/ecs/ecs.config;
EOF
      instance_type        = "t2.micro"
      key_name               = aws_key_pair.key_pair.id
      lifecycle {
            create_before_destroy = true
      }
}

# AutoScaling Group
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
